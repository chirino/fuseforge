<?php
/**
* Crowd auth plug-in for phpBB3
* 
* Put this file in $PHPBB3/includes/auth/
* Configure under Client communication -> Authentication in the Management UI
*
* See http://wiki.phpbb.com/Authentication_plugins
*
* Requires http://pear.php.net/package/Services_Atlassian_Crowd
* for 0.9.4 try 
*      # pear install Services_Atlassian_Crowd-beta
* 
*/
require_once 'Services/Atlassian/Crowd.php';

/**
* @ignore
*/
if (!defined('IN_PHPBB'))
{
	exit;
}

/**
* Checks Crowd configuration.
* Only allow changing authentication to Crowd if we can successfully authenticate the application with Crowd.
* Called in acp_board while setting authentication plugins.
*
* @return boolean|string false if the application can authenticate else an error message
*/
function init_crowd()
{    
	try
	{
	    get_crowd_connection();
	    return false;
	}
	catch (Exception $e)
	{
        return 'Can not connect to the Crowd Server.  Please check the configuration settings.';    	
	}

}

/**
* Login function
*/
function login_crowd(&$username, &$password)
{

	if (!$password)
	{
		return array(
			'status'	=> LOGIN_ERROR_PASSWORD,
			'error_msg'	=> 'NO_PASSWORD_SUPPLIED',
			'user_row'	=> array('user_id' => ANONYMOUS),
		);
	}

	if (!$username)
	{
		return array(
			'status'	=> LOGIN_ERROR_USERNAME,
			'error_msg'	=> 'LOGIN_ERROR_USERNAME',
			'user_row'	=> array('user_id' => ANONYMOUS),
		);
	}

    try
    {
        $crowd = get_crowd_connection();
    }
    catch(Exception $e)
    {
    	return array(
    		'status'		=> LOGIN_ERROR_EXTERNAL_AUTH,
    		'error_msg'		=> 'Can not connect to the Authentication Server.',
    		'user_row'		=> array('user_id' => ANONYMOUS),
    	);
    }

	try 
	{
        $crowd_user_token = $crowd->authenticatePrincipal($username,
                                                     $password,
                                                     $_SERVER['HTTP_USER_AGENT'],
                                                     $_SERVER['REMOTE_ADDR']);
													
    	// setting this cookie allows us to log into other Crowd applications
    	setcookie("crowd.token_key", $crowd_user_token, 0, "/");
	}
	catch(Exception $e)
	{
		return array(
			'status'		=> LOGIN_ERROR_EXTERNAL_AUTH,
			'error_msg'		=> 'LOGIN_ERROR_PASSWORD',
			'user_row'		=> array('user_id' => ANONYMOUS),
		);
	}
	
	// At this point Crowd thinks we're a valid user
	    
    $row = load_user($username);
	if ($row)
	{
		// Successful login...
		return array(
			'status'		=> LOGIN_SUCCESS,
			'error_msg'		=> false,
			'user_row'		=> $row,
		);
	}
    else
    {
		// this is the user's first login so create an empty profile
		$crowd_user = $crowd->findPrincipalByToken($crowd_user_token);
        $row = create_user_row($crowd_user);
        
		return array(
			'status'		=> LOGIN_SUCCESS_CREATE_PROFILE,
			'error_msg'		=> false,
			'user_row'		=> $row,
		);
    }
}


/**
*  Called from includes/session.php when the user session is terminated (for example, the user presses the logout link).
* 
* Input parameters:
*  - $user_row: User+Session row array (a join of the USERS_TABLE and SESSIONS_TABLE)
*  - $new_session: ??? 
* 
* No return value is expected from the logout method.
*/
function logout_crowd($user_row, $new_session)
{
	try {
	    if (crowd_cookie_exists())
	    {
	        $crowd = get_crowd_connection();
	        $crowd->invalidatePrincipalToken(get_crowd_token());        
        }
	}
	catch(Exception $e)
	{
        // do nothing
	}

    // remove the crowd cookie
	setcookie("crowd.token_key", "", time() - 3600, "/");
}

/**
* Autologin function
* http://wiki.phpbb.com/Authentication_plugins#autologin_method
*
* @return array containing the user row or empty if no auto login should take place
*/
function autologin_crowd()
{	
					
	if (is_logged_into_crowd())
	{		
	    $crowd = get_crowd_connection();             				
        $crowd_user = $crowd->findPrincipalByToken(get_crowd_token());
	
    	// TODO can $crowd_user be empty or does it throw an exception?
    	if (!empty($crowd_user))
    	{
    		$row = load_user($crowd_user->name, true);
    		if ($row)
    		{
    			return ($row['user_type'] == USER_INACTIVE || $row['user_type'] == USER_IGNORE) ? array() : $row;
    		}
		
    		// TODO ick.  Can this be included somewhere else?
    		if (!function_exists('user_add'))
    		{
    			global $phpbb_root_path, $phpEx;

    			include($phpbb_root_path . 'includes/functions_user.' . $phpEx);
    		}

    		user_add(create_user_row($crowd_user));        
    		$row = load_user($crowd_user->name, true);    		
    		if ($row)
    		{
    			return $row;
    		}
    	}
    }

	return array();
}

/**
* The session validation function checks whether the user is still logged in
*
* @return boolean true if the given user is authenticated or false if the session should be closed
*/
function validate_session_crowd(&$user)
{
        
    if ($user['user_id'] == ANONYMOUS)
    {
        // an anonymous user is OK as long as there is not a crowd token cookie
        return (!crowd_cookie_exists());
    }
    else
    {
        if (is_logged_into_crowd())
        {
            $crowd = get_crowd_connection();
    		$crowd_user = $crowd->findPrincipalByToken(get_crowd_token());
            return $crowd_user->name == $user['username'];
        }
        else 
        {
            return false;
        }
    }
}

/**
* This function is used to output any required fields in the authentication
* admin panel. It also defines any required configuration table fields.
*/
function acp_crowd(&$new)
{
	global $user;
	
	// TODO: these need to go in an i18n file like phpBB3/language/en/acp/board.php
	$user->lang['CROWD_URL'] = "Crowd Application URL";
	$user->lang['CROWD_URL_EXPLAIN'] = "The URL to use when connecting with the integration libraries to communicate with the Crowd server.<br>example: http://localhost:8095/crowd/services/SecurityServer?wsdl";
	$user->lang['CROWD_APP_NAME'] = "Crowd Application Name";
	$user->lang['CROWD_APP_NAME_EXPLAIN'] = 'The name that the application will use when authenticating with the Crowd server. This needs to match the name you specified in <a href="http://confluence.atlassian.com/display/CROWD/Adding+an+Application">Adding an Application.</a>';
	$user->lang['CROWD_APP_PASSWORD'] = "Crowd Application Password";
	$user->lang['CROWD_APP_PASSWORD_EXPLAIN'] = 'The password that the application will use when authenticating with the Crowd server. This needs to match the password you specified in <a href="http://confluence.atlassian.com/display/CROWD/Adding+an+Application">Adding an Application.</a>';

	$tpl = '
	
	<dl>
		<dt><label for="crowd_url">' . $user->lang['CROWD_URL'] . ':</label><br /><span>' . $user->lang['CROWD_URL_EXPLAIN'] . '</span></dt>
		<dd><input type="text" id="crowd_url" size="40" name="config[crowd_url]" value="' . $new['crowd_url'] . '" /></dd>
	</dl>
	<dl>
		<dt><label for="crowd_app_name">' . $user->lang['CROWD_APP_NAME'] . ':</label><br /><span>' . $user->lang['CROWD_APP_NAME_EXPLAIN'] . '</span></dt>
		<dd><input type="text" id="crowd_app_name" size="40" name="config[crowd_app_name]" value="' . $new['crowd_app_name'] . '" /></dd>
	</dl>
	<dl>
		<dt><label for="crowd_app_password">' . $user->lang['CROWD_APP_PASSWORD'] . ':</label><br /><span>' . $user->lang['CROWD_APP_PASSWORD_EXPLAIN'] . '</span></dt>
		<dd><input type="password" id="crowd_app_password" size="40" name="config[crowd_app_password]" value="' . $new['crowd_app_password'] . '" /></dd>
	</dl>	
	';

	// These are fields required in the config table
	return array(
		'tpl'		=> $tpl,
		'config'	=> array('crowd_url', 'crowd_app_name', 'crowd_app_password')
	);
}

// private
/**
* This function generates an array which can be passed to the user_add function in order to create a user
*/
function create_user_row($crowd_user)
{
    
	global $db, $config, $user;
	// first retrieve default group id
	$sql = 'SELECT group_id
		FROM ' . GROUPS_TABLE . "
		WHERE group_name = '" . $db->sql_escape('REGISTERED') . "'
			AND group_type = " . GROUP_SPECIAL;
	$result = $db->sql_query($sql);
	$row = $db->sql_fetchrow($result);
	$db->sql_freeresult($result);

	if (!$row)
	{
		trigger_error('NO_GROUP');
	}

    $email = get_email_from_crowd_user($crowd_user);

	// crowd has the real password, storing junk here
	return array(
		'username'		=> $crowd_user->name,
		'user_password'	=> phpbb_hash(uniqid()),
		'user_email'	=> $email,
		'group_id'		=> (int) $row['group_id'],
		'user_type'		=> USER_NORMAL,
		'user_ip'		=> $user->ip,
	);
}

// private
function get_email_from_crowd_user($crowd_user)
{
    $attributes = $crowd_user->attributes->SOAPAttribute;
    foreach($attributes as $attribute)
    {
        if ($attribute->name == "mail")
        {
            return $attribute->values->string;
        }
    }
    return "";
}

// private
function is_logged_into_crowd()
{
    if (!crowd_cookie_exists())
    {
        return false;
    }

    try 
    {
      $crowd = get_crowd_connection();		
      return $crowd->isValidPrincipalToken(get_crowd_token(), $_SERVER['HTTP_USER_AGENT'], $_SERVER['REMOTE_ADDR']);
    }
    catch(Exception $e)
    {
      return false;
    }
}

// private
/** 
 * Connect to Crowd 
 * returns a server object
 * 
 * TODO how can we gracefully handle connection problems?
 */
function get_crowd_connection()
{
    global $config;
    
    $crowd_options = array('app_name' => $config['crowd_app_name'],
	                       'app_credential' => $config['crowd_app_password'],
	                       'service_url' => $config['crowd_url']);

    $crowd = new Services_Atlassian_Crowd($crowd_options);
    $application_token = $crowd->authenticateApplication();
    
    return $crowd;
}

// private
/**
* Loads a user from the database by name.
*/
function load_user(&$username, $all_columns = false)
{
    global $db;
    
    $cols = $all_columns ? "*" : "user_id, username, user_password, user_passchg, user_email, user_type";

    $sql = "SELECT $cols " . 
		" FROM " . USERS_TABLE . 
		" WHERE username = '" . $db->sql_escape($username) . "'";
	$result = $db->sql_query($sql);
	$row = $db->sql_fetchrow($result);
	$db->sql_freeresult($result);

	return $row;
}

// private
// note the real cookie is crowd.token_key but php munges the name
function crowd_cookie_exists()
{
    return array_key_exists('crowd_token_key', $_COOKIE);
}

// private
// note the real cookie is crowd.token_key but php munges the name
function get_crowd_token()
{
    return $_COOKIE["crowd_token_key"];
}

?>