#!/usr/bin/env ruby
require 'defaultDriver.rb'

endpoint_url = ARGV.shift
obj = JiraSoapService.new(endpoint_url)

# run ruby with -d to see SOAP wiredumps.
obj.wiredump_dev = STDERR if $DEBUG

# SYNOPSIS
#   getComment(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             Long - {http://www.w3.org/2001/XMLSchema}long
#
# RETURNS
#   getCommentReturn RemoteComment - {http://beans.soap.rpc.jira.atlassian.com}RemoteComment
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.getComment(in0, in1)

# SYNOPSIS
#   createGroup(in0, in1, in2)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in2             RemoteUser - {http://beans.soap.rpc.jira.atlassian.com}RemoteUser
#
# RETURNS
#   createGroupReturn RemoteGroup - {http://beans.soap.rpc.jira.atlassian.com}RemoteGroup
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = nil
puts obj.createGroup(in0, in1, in2)

# SYNOPSIS
#   getServerInfo(in0)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getServerInfoReturn RemoteServerInfo - {http://beans.soap.rpc.jira.atlassian.com}RemoteServerInfo
#
in0 = nil
puts obj.getServerInfo(in0)

# SYNOPSIS
#   getGroup(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getGroupReturn  RemoteGroup - {http://beans.soap.rpc.jira.atlassian.com}RemoteGroup
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.getGroup(in0, in1)

# SYNOPSIS
#   login(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   loginReturn     C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RAISES
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.login(in0, in1)

# SYNOPSIS
#   getUser(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getUserReturn   RemoteUser - {http://beans.soap.rpc.jira.atlassian.com}RemoteUser
#
# RAISES
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#
in0 = in1 = nil
puts obj.getUser(in0, in1)

# SYNOPSIS
#   createUser(in0, in1, in2, in3, in4)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in2             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in3             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in4             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   createUserReturn RemoteUser - {http://beans.soap.rpc.jira.atlassian.com}RemoteUser
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = in3 = in4 = nil
puts obj.createUser(in0, in1, in2, in3, in4)

# SYNOPSIS
#   getIssue(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getIssueReturn  RemoteIssue - {http://beans.soap.rpc.jira.atlassian.com}RemoteIssue
#
# RAISES
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.getIssue(in0, in1)

# SYNOPSIS
#   createIssue(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             RemoteIssue - {http://beans.soap.rpc.jira.atlassian.com}RemoteIssue
#
# RETURNS
#   createIssueReturn RemoteIssue - {http://beans.soap.rpc.jira.atlassian.com}RemoteIssue
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.createIssue(in0, in1)

# SYNOPSIS
#   getAvailableActions(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getAvailableActionsReturn ArrayOf_tns1_RemoteNamedObject - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteNamedObject
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.getAvailableActions(in0, in1)

# SYNOPSIS
#   updateIssue(in0, in1, in2)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in2             ArrayOf_tns1_RemoteFieldValue - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteFieldValue
#
# RETURNS
#   updateIssueReturn RemoteIssue - {http://beans.soap.rpc.jira.atlassian.com}RemoteIssue
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = nil
puts obj.updateIssue(in0, in1, in2)

# SYNOPSIS
#   getConfiguration(in0)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getConfigurationReturn RemoteConfiguration - {http://beans.soap.rpc.jira.atlassian.com}RemoteConfiguration
#
# RAISES
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = nil
puts obj.getConfiguration(in0)

# SYNOPSIS
#   getComponents(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getComponentsReturn ArrayOf_tns1_RemoteComponent - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteComponent
#
# RAISES
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.getComponents(in0, in1)

# SYNOPSIS
#   getSecurityLevel(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getSecurityLevelReturn RemoteSecurityLevel - {http://beans.soap.rpc.jira.atlassian.com}RemoteSecurityLevel
#
# RAISES
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.getSecurityLevel(in0, in1)

# SYNOPSIS
#   updateProject(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             RemoteProject - {http://beans.soap.rpc.jira.atlassian.com}RemoteProject
#
# RETURNS
#   updateProjectReturn RemoteProject - {http://beans.soap.rpc.jira.atlassian.com}RemoteProject
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.updateProject(in0, in1)

# SYNOPSIS
#   getProjectByKey(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getProjectByKeyReturn RemoteProject - {http://beans.soap.rpc.jira.atlassian.com}RemoteProject
#
# RAISES
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.getProjectByKey(in0, in1)

# SYNOPSIS
#   getPriorities(in0)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getPrioritiesReturn ArrayOf_tns1_RemotePriority - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemotePriority
#
# RAISES
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#
in0 = nil
puts obj.getPriorities(in0)

# SYNOPSIS
#   getResolutions(in0)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getResolutionsReturn ArrayOf_tns1_RemoteResolution - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteResolution
#
# RAISES
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#
in0 = nil
puts obj.getResolutions(in0)

# SYNOPSIS
#   getIssueTypes(in0)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getIssueTypesReturn ArrayOf_tns1_RemoteIssueType - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteIssueType
#
# RAISES
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#
in0 = nil
puts obj.getIssueTypes(in0)

# SYNOPSIS
#   getStatuses(in0)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getStatusesReturn ArrayOf_tns1_RemoteStatus - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteStatus
#
# RAISES
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#
in0 = nil
puts obj.getStatuses(in0)

# SYNOPSIS
#   getSubTaskIssueTypes(in0)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getSubTaskIssueTypesReturn ArrayOf_tns1_RemoteIssueType - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteIssueType
#
# RAISES
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#
in0 = nil
puts obj.getSubTaskIssueTypes(in0)

# SYNOPSIS
#   getProjectRoles(in0)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getProjectRolesReturn ArrayOf_tns1_RemoteProjectRole - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteProjectRole
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = nil
puts obj.getProjectRoles(in0)

# SYNOPSIS
#   getProjectRole(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             Long - {http://www.w3.org/2001/XMLSchema}long
#
# RETURNS
#   getProjectRoleReturn RemoteProjectRole - {http://beans.soap.rpc.jira.atlassian.com}RemoteProjectRole
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.getProjectRole(in0, in1)

# SYNOPSIS
#   getProjectRoleActors(in0, in1, in2)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             RemoteProjectRole - {http://beans.soap.rpc.jira.atlassian.com}RemoteProjectRole
#   in2             RemoteProject - {http://beans.soap.rpc.jira.atlassian.com}RemoteProject
#
# RETURNS
#   getProjectRoleActorsReturn RemoteProjectRoleActors - {http://beans.soap.rpc.jira.atlassian.com}RemoteProjectRoleActors
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = nil
puts obj.getProjectRoleActors(in0, in1, in2)

# SYNOPSIS
#   getDefaultRoleActors(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             RemoteProjectRole - {http://beans.soap.rpc.jira.atlassian.com}RemoteProjectRole
#
# RETURNS
#   getDefaultRoleActorsReturn RemoteRoleActors - {http://beans.soap.rpc.jira.atlassian.com}RemoteRoleActors
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.getDefaultRoleActors(in0, in1)

# SYNOPSIS
#   removeAllRoleActorsByNameAndType(in0, in1, in2)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in2             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   N/A
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = nil
puts obj.removeAllRoleActorsByNameAndType(in0, in1, in2)

# SYNOPSIS
#   removeAllRoleActorsByProject(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             RemoteProject - {http://beans.soap.rpc.jira.atlassian.com}RemoteProject
#
# RETURNS
#   N/A
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.removeAllRoleActorsByProject(in0, in1)

# SYNOPSIS
#   deleteProjectRole(in0, in1, in2)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             RemoteProjectRole - {http://beans.soap.rpc.jira.atlassian.com}RemoteProjectRole
#   in2             Boolean - {http://www.w3.org/2001/XMLSchema}boolean
#
# RETURNS
#   N/A
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = nil
puts obj.deleteProjectRole(in0, in1, in2)

# SYNOPSIS
#   updateProjectRole(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             RemoteProjectRole - {http://beans.soap.rpc.jira.atlassian.com}RemoteProjectRole
#
# RETURNS
#   N/A
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.updateProjectRole(in0, in1)

# SYNOPSIS
#   createProjectRole(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             RemoteProjectRole - {http://beans.soap.rpc.jira.atlassian.com}RemoteProjectRole
#
# RETURNS
#   createProjectRoleReturn RemoteProjectRole - {http://beans.soap.rpc.jira.atlassian.com}RemoteProjectRole
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.createProjectRole(in0, in1)

# SYNOPSIS
#   isProjectRoleNameUnique(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   isProjectRoleNameUniqueReturn Boolean - {http://www.w3.org/2001/XMLSchema}boolean
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.isProjectRoleNameUnique(in0, in1)

# SYNOPSIS
#   addActorsToProjectRole(in0, in1, in2, in3, in4)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             ArrayOf_xsd_string - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_xsd_string
#   in2             RemoteProjectRole - {http://beans.soap.rpc.jira.atlassian.com}RemoteProjectRole
#   in3             RemoteProject - {http://beans.soap.rpc.jira.atlassian.com}RemoteProject
#   in4             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   N/A
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = in3 = in4 = nil
puts obj.addActorsToProjectRole(in0, in1, in2, in3, in4)

# SYNOPSIS
#   removeActorsFromProjectRole(in0, in1, in2, in3, in4)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             ArrayOf_xsd_string - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_xsd_string
#   in2             RemoteProjectRole - {http://beans.soap.rpc.jira.atlassian.com}RemoteProjectRole
#   in3             RemoteProject - {http://beans.soap.rpc.jira.atlassian.com}RemoteProject
#   in4             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   N/A
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = in3 = in4 = nil
puts obj.removeActorsFromProjectRole(in0, in1, in2, in3, in4)

# SYNOPSIS
#   addDefaultActorsToProjectRole(in0, in1, in2, in3)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             ArrayOf_xsd_string - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_xsd_string
#   in2             RemoteProjectRole - {http://beans.soap.rpc.jira.atlassian.com}RemoteProjectRole
#   in3             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   N/A
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = in3 = nil
puts obj.addDefaultActorsToProjectRole(in0, in1, in2, in3)

# SYNOPSIS
#   removeDefaultActorsFromProjectRole(in0, in1, in2, in3)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             ArrayOf_xsd_string - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_xsd_string
#   in2             RemoteProjectRole - {http://beans.soap.rpc.jira.atlassian.com}RemoteProjectRole
#   in3             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   N/A
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = in3 = nil
puts obj.removeDefaultActorsFromProjectRole(in0, in1, in2, in3)

# SYNOPSIS
#   getAssociatedNotificationSchemes(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             RemoteProjectRole - {http://beans.soap.rpc.jira.atlassian.com}RemoteProjectRole
#
# RETURNS
#   getAssociatedNotificationSchemesReturn ArrayOf_tns1_RemoteScheme - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteScheme
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.getAssociatedNotificationSchemes(in0, in1)

# SYNOPSIS
#   getAssociatedPermissionSchemes(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             RemoteProjectRole - {http://beans.soap.rpc.jira.atlassian.com}RemoteProjectRole
#
# RETURNS
#   getAssociatedPermissionSchemesReturn ArrayOf_tns1_RemoteScheme - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteScheme
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.getAssociatedPermissionSchemes(in0, in1)

# SYNOPSIS
#   getCustomFields(in0)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getCustomFieldsReturn ArrayOf_tns1_RemoteField - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteField
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = nil
puts obj.getCustomFields(in0)

# SYNOPSIS
#   getComments(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getCommentsReturn ArrayOf_tns1_RemoteComment - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteComment
#
# RAISES
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.getComments(in0, in1)

# SYNOPSIS
#   getFavouriteFilters(in0)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getFavouriteFiltersReturn ArrayOf_tns1_RemoteFilter - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteFilter
#
# RAISES
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = nil
puts obj.getFavouriteFilters(in0)

# SYNOPSIS
#   archiveVersion(in0, in1, in2, in3)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in2             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in3             Boolean - {http://www.w3.org/2001/XMLSchema}boolean
#
# RETURNS
#   N/A
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = in3 = nil
puts obj.archiveVersion(in0, in1, in2, in3)

# SYNOPSIS
#   getVersions(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getVersionsReturn ArrayOf_tns1_RemoteVersion - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteVersion
#
# RAISES
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.getVersions(in0, in1)

# SYNOPSIS
#   createProject(in0, in1, in2, in3, in4, in5, in6, in7, in8)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in2             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in3             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in4             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in5             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in6             RemotePermissionScheme - {http://beans.soap.rpc.jira.atlassian.com}RemotePermissionScheme
#   in7             RemoteScheme - {http://beans.soap.rpc.jira.atlassian.com}RemoteScheme
#   in8             RemoteScheme - {http://beans.soap.rpc.jira.atlassian.com}RemoteScheme
#
# RETURNS
#   createProjectReturn RemoteProject - {http://beans.soap.rpc.jira.atlassian.com}RemoteProject
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = in3 = in4 = in5 = in6 = in7 = in8 = nil
puts obj.createProject(in0, in1, in2, in3, in4, in5, in6, in7, in8)

# SYNOPSIS
#   addComment(in0, in1, in2)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in2             RemoteComment - {http://beans.soap.rpc.jira.atlassian.com}RemoteComment
#
# RETURNS
#   N/A
#
# RAISES
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = nil
puts obj.addComment(in0, in1, in2)

# SYNOPSIS
#   getFieldsForEdit(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getFieldsForEditReturn ArrayOf_tns1_RemoteField - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteField
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.getFieldsForEdit(in0, in1)

# SYNOPSIS
#   getIssueTypesForProject(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getIssueTypesForProjectReturn ArrayOf_tns1_RemoteIssueType - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteIssueType
#
# RAISES
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#
in0 = in1 = nil
puts obj.getIssueTypesForProject(in0, in1)

# SYNOPSIS
#   getSubTaskIssueTypesForProject(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getSubTaskIssueTypesForProjectReturn ArrayOf_tns1_RemoteIssueType - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteIssueType
#
# RAISES
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#
in0 = in1 = nil
puts obj.getSubTaskIssueTypesForProject(in0, in1)

# SYNOPSIS
#   addUserToGroup(in0, in1, in2)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             RemoteGroup - {http://beans.soap.rpc.jira.atlassian.com}RemoteGroup
#   in2             RemoteUser - {http://beans.soap.rpc.jira.atlassian.com}RemoteUser
#
# RETURNS
#   N/A
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = nil
puts obj.addUserToGroup(in0, in1, in2)

# SYNOPSIS
#   removeUserFromGroup(in0, in1, in2)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             RemoteGroup - {http://beans.soap.rpc.jira.atlassian.com}RemoteGroup
#   in2             RemoteUser - {http://beans.soap.rpc.jira.atlassian.com}RemoteUser
#
# RETURNS
#   N/A
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = nil
puts obj.removeUserFromGroup(in0, in1, in2)

# SYNOPSIS
#   logout(in0)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   logoutReturn    Boolean - {http://www.w3.org/2001/XMLSchema}boolean
#
in0 = nil
puts obj.logout(in0)

# SYNOPSIS
#   getProjectById(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             Long - {http://www.w3.org/2001/XMLSchema}long
#
# RETURNS
#   getProjectByIdReturn RemoteProject - {http://beans.soap.rpc.jira.atlassian.com}RemoteProject
#
# RAISES
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.getProjectById(in0, in1)

# SYNOPSIS
#   getProjectWithSchemesById(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             Long - {http://www.w3.org/2001/XMLSchema}long
#
# RETURNS
#   getProjectWithSchemesByIdReturn RemoteProject - {http://beans.soap.rpc.jira.atlassian.com}RemoteProject
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.getProjectWithSchemesById(in0, in1)

# SYNOPSIS
#   deleteProject(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   N/A
#
# RAISES
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.deleteProject(in0, in1)

# SYNOPSIS
#   releaseVersion(in0, in1, in2)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in2             RemoteVersion - {http://beans.soap.rpc.jira.atlassian.com}RemoteVersion
#
# RETURNS
#   N/A
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = nil
puts obj.releaseVersion(in0, in1, in2)

# SYNOPSIS
#   getSecurityLevels(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getSecurityLevelsReturn ArrayOf_tns1_RemoteSecurityLevel - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteSecurityLevel
#
# RAISES
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.getSecurityLevels(in0, in1)

# SYNOPSIS
#   deleteIssue(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   N/A
#
# RAISES
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.deleteIssue(in0, in1)

# SYNOPSIS
#   createIssueWithSecurityLevel(in0, in1, in2)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             RemoteIssue - {http://beans.soap.rpc.jira.atlassian.com}RemoteIssue
#   in2             Long - {http://www.w3.org/2001/XMLSchema}long
#
# RETURNS
#   createIssueWithSecurityLevelReturn RemoteIssue - {http://beans.soap.rpc.jira.atlassian.com}RemoteIssue
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = nil
puts obj.createIssueWithSecurityLevel(in0, in1, in2)

# SYNOPSIS
#   addAttachmentsToIssue(in0, in1, in2, in3)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in2             ArrayOf_xsd_string - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_xsd_string
#   in3             ArrayOf_xsd_base64Binary - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_xsd_base64Binary
#
# RETURNS
#   addAttachmentsToIssueReturn Boolean - {http://www.w3.org/2001/XMLSchema}boolean
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = in3 = nil
puts obj.addAttachmentsToIssue(in0, in1, in2, in3)

# SYNOPSIS
#   getAttachmentsFromIssue(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getAttachmentsFromIssueReturn ArrayOf_tns1_RemoteAttachment - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteAttachment
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.getAttachmentsFromIssue(in0, in1)

# SYNOPSIS
#   hasPermissionToEditComment(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             RemoteComment - {http://beans.soap.rpc.jira.atlassian.com}RemoteComment
#
# RETURNS
#   hasPermissionToEditCommentReturn Boolean - {http://www.w3.org/2001/XMLSchema}boolean
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.hasPermissionToEditComment(in0, in1)

# SYNOPSIS
#   editComment(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             RemoteComment - {http://beans.soap.rpc.jira.atlassian.com}RemoteComment
#
# RETURNS
#   editCommentReturn RemoteComment - {http://beans.soap.rpc.jira.atlassian.com}RemoteComment
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.editComment(in0, in1)

# SYNOPSIS
#   getFieldsForAction(in0, in1, in2)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in2             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getFieldsForActionReturn ArrayOf_tns1_RemoteField - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteField
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = nil
puts obj.getFieldsForAction(in0, in1, in2)

# SYNOPSIS
#   progressWorkflowAction(in0, in1, in2, in3)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in2             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in3             ArrayOf_tns1_RemoteFieldValue - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteFieldValue
#
# RETURNS
#   progressWorkflowActionReturn RemoteIssue - {http://beans.soap.rpc.jira.atlassian.com}RemoteIssue
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = in3 = nil
puts obj.progressWorkflowAction(in0, in1, in2, in3)

# SYNOPSIS
#   getIssueById(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getIssueByIdReturn RemoteIssue - {http://beans.soap.rpc.jira.atlassian.com}RemoteIssue
#
# RAISES
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.getIssueById(in0, in1)

# SYNOPSIS
#   addWorklogWithNewRemainingEstimate(in0, in1, in2, in3)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in2             RemoteWorklog - {http://beans.soap.rpc.jira.atlassian.com}RemoteWorklog
#   in3             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   addWorklogWithNewRemainingEstimateReturn RemoteWorklog - {http://beans.soap.rpc.jira.atlassian.com}RemoteWorklog
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = in3 = nil
puts obj.addWorklogWithNewRemainingEstimate(in0, in1, in2, in3)

# SYNOPSIS
#   addWorklogAndAutoAdjustRemainingEstimate(in0, in1, in2)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in2             RemoteWorklog - {http://beans.soap.rpc.jira.atlassian.com}RemoteWorklog
#
# RETURNS
#   addWorklogAndAutoAdjustRemainingEstimateReturn RemoteWorklog - {http://beans.soap.rpc.jira.atlassian.com}RemoteWorklog
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = nil
puts obj.addWorklogAndAutoAdjustRemainingEstimate(in0, in1, in2)

# SYNOPSIS
#   addWorklogAndRetainRemainingEstimate(in0, in1, in2)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in2             RemoteWorklog - {http://beans.soap.rpc.jira.atlassian.com}RemoteWorklog
#
# RETURNS
#   addWorklogAndRetainRemainingEstimateReturn RemoteWorklog - {http://beans.soap.rpc.jira.atlassian.com}RemoteWorklog
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = nil
puts obj.addWorklogAndRetainRemainingEstimate(in0, in1, in2)

# SYNOPSIS
#   deleteWorklogWithNewRemainingEstimate(in0, in1, in2)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in2             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   N/A
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = nil
puts obj.deleteWorklogWithNewRemainingEstimate(in0, in1, in2)

# SYNOPSIS
#   deleteWorklogAndAutoAdjustRemainingEstimate(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   N/A
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.deleteWorklogAndAutoAdjustRemainingEstimate(in0, in1)

# SYNOPSIS
#   deleteWorklogAndRetainRemainingEstimate(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   N/A
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.deleteWorklogAndRetainRemainingEstimate(in0, in1)

# SYNOPSIS
#   updateWorklogWithNewRemainingEstimate(in0, in1, in2)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             RemoteWorklog - {http://beans.soap.rpc.jira.atlassian.com}RemoteWorklog
#   in2             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   N/A
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = nil
puts obj.updateWorklogWithNewRemainingEstimate(in0, in1, in2)

# SYNOPSIS
#   updateWorklogAndAutoAdjustRemainingEstimate(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             RemoteWorklog - {http://beans.soap.rpc.jira.atlassian.com}RemoteWorklog
#
# RETURNS
#   N/A
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.updateWorklogAndAutoAdjustRemainingEstimate(in0, in1)

# SYNOPSIS
#   updateWorklogAndRetainRemainingEstimate(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             RemoteWorklog - {http://beans.soap.rpc.jira.atlassian.com}RemoteWorklog
#
# RETURNS
#   N/A
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.updateWorklogAndRetainRemainingEstimate(in0, in1)

# SYNOPSIS
#   getWorklogs(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getWorklogsReturn ArrayOf_tns1_RemoteWorklog - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteWorklog
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.getWorklogs(in0, in1)

# SYNOPSIS
#   hasPermissionToCreateWorklog(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   hasPermissionToCreateWorklogReturn Boolean - {http://www.w3.org/2001/XMLSchema}boolean
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.hasPermissionToCreateWorklog(in0, in1)

# SYNOPSIS
#   hasPermissionToDeleteWorklog(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   hasPermissionToDeleteWorklogReturn Boolean - {http://www.w3.org/2001/XMLSchema}boolean
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.hasPermissionToDeleteWorklog(in0, in1)

# SYNOPSIS
#   hasPermissionToUpdateWorklog(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   hasPermissionToUpdateWorklogReturn Boolean - {http://www.w3.org/2001/XMLSchema}boolean
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.hasPermissionToUpdateWorklog(in0, in1)

# SYNOPSIS
#   getNotificationSchemes(in0)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getNotificationSchemesReturn ArrayOf_tns1_RemoteScheme - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteScheme
#
# RAISES
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = nil
puts obj.getNotificationSchemes(in0)

# SYNOPSIS
#   getPermissionSchemes(in0)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getPermissionSchemesReturn ArrayOf_tns1_RemotePermissionScheme - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemotePermissionScheme
#
# RAISES
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = nil
puts obj.getPermissionSchemes(in0)

# SYNOPSIS
#   createPermissionScheme(in0, in1, in2)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in2             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   createPermissionSchemeReturn RemotePermissionScheme - {http://beans.soap.rpc.jira.atlassian.com}RemotePermissionScheme
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = nil
puts obj.createPermissionScheme(in0, in1, in2)

# SYNOPSIS
#   deletePermissionScheme(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   N/A
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.deletePermissionScheme(in0, in1)

# SYNOPSIS
#   addPermissionTo(in0, in1, in2, in3)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             RemotePermissionScheme - {http://beans.soap.rpc.jira.atlassian.com}RemotePermissionScheme
#   in2             RemotePermission - {http://beans.soap.rpc.jira.atlassian.com}RemotePermission
#   in3             RemoteEntity - {http://beans.soap.rpc.jira.atlassian.com}RemoteEntity
#
# RETURNS
#   addPermissionToReturn RemotePermissionScheme - {http://beans.soap.rpc.jira.atlassian.com}RemotePermissionScheme
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = in3 = nil
puts obj.addPermissionTo(in0, in1, in2, in3)

# SYNOPSIS
#   deletePermissionFrom(in0, in1, in2, in3)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             RemotePermissionScheme - {http://beans.soap.rpc.jira.atlassian.com}RemotePermissionScheme
#   in2             RemotePermission - {http://beans.soap.rpc.jira.atlassian.com}RemotePermission
#   in3             RemoteEntity - {http://beans.soap.rpc.jira.atlassian.com}RemoteEntity
#
# RETURNS
#   deletePermissionFromReturn RemotePermissionScheme - {http://beans.soap.rpc.jira.atlassian.com}RemotePermissionScheme
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = in3 = nil
puts obj.deletePermissionFrom(in0, in1, in2, in3)

# SYNOPSIS
#   getAllPermissions(in0)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getAllPermissionsReturn ArrayOf_tns1_RemotePermission - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemotePermission
#
# RAISES
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = nil
puts obj.getAllPermissions(in0)

# SYNOPSIS
#   getIssueCountForFilter(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getIssueCountForFilterReturn Long - {http://www.w3.org/2001/XMLSchema}long
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.getIssueCountForFilter(in0, in1)

# SYNOPSIS
#   getIssuesFromTextSearch(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getIssuesFromTextSearchReturn ArrayOf_tns1_RemoteIssue - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteIssue
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.getIssuesFromTextSearch(in0, in1)

# SYNOPSIS
#   getIssuesFromTextSearchWithProject(in0, in1, in2, in3)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             ArrayOf_xsd_string - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_xsd_string
#   in2             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in3             Int - {http://www.w3.org/2001/XMLSchema}int
#
# RETURNS
#   getIssuesFromTextSearchWithProjectReturn ArrayOf_tns1_RemoteIssue - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteIssue
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = in3 = nil
puts obj.getIssuesFromTextSearchWithProject(in0, in1, in2, in3)

# SYNOPSIS
#   deleteUser(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   N/A
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.deleteUser(in0, in1)

# SYNOPSIS
#   updateGroup(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             RemoteGroup - {http://beans.soap.rpc.jira.atlassian.com}RemoteGroup
#
# RETURNS
#   updateGroupReturn RemoteGroup - {http://beans.soap.rpc.jira.atlassian.com}RemoteGroup
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.updateGroup(in0, in1)

# SYNOPSIS
#   deleteGroup(in0, in1, in2)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in2             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   N/A
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = nil
puts obj.deleteGroup(in0, in1, in2)

# SYNOPSIS
#   refreshCustomFields(in0)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   N/A
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = nil
puts obj.refreshCustomFields(in0)

# SYNOPSIS
#   getProjectsNoSchemes(in0)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getProjectsNoSchemesReturn ArrayOf_tns1_RemoteProject - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteProject
#
# RAISES
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = nil
puts obj.getProjectsNoSchemes(in0)

# SYNOPSIS
#   addVersion(in0, in1, in2)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in2             RemoteVersion - {http://beans.soap.rpc.jira.atlassian.com}RemoteVersion
#
# RETURNS
#   addVersionReturn RemoteVersion - {http://beans.soap.rpc.jira.atlassian.com}RemoteVersion
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = in2 = nil
puts obj.addVersion(in0, in1, in2)

# SYNOPSIS
#   getSavedFilters(in0)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getSavedFiltersReturn ArrayOf_tns1_RemoteFilter - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteFilter
#
# RAISES
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = nil
puts obj.getSavedFilters(in0)

# SYNOPSIS
#   createProjectFromObject(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             RemoteProject - {http://beans.soap.rpc.jira.atlassian.com}RemoteProject
#
# RETURNS
#   createProjectFromObjectReturn RemoteProject - {http://beans.soap.rpc.jira.atlassian.com}RemoteProject
#
# RAISES
#   fault           RemoteValidationException - {http://exception.rpc.jira.atlassian.com}RemoteValidationException
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.createProjectFromObject(in0, in1)

# SYNOPSIS
#   getSecuritySchemes(in0)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getSecuritySchemesReturn ArrayOf_tns1_RemoteScheme - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteScheme
#
# RAISES
#   fault           RemotePermissionException - {http://exception.rpc.jira.atlassian.com}RemotePermissionException
#   fault           RemoteAuthenticationException - {http://exception.rpc.jira.atlassian.com}RemoteAuthenticationException
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = nil
puts obj.getSecuritySchemes(in0)

# SYNOPSIS
#   getIssuesFromFilter(in0, in1)
#
# ARGS
#   in0             C_String - {http://www.w3.org/2001/XMLSchema}string
#   in1             C_String - {http://www.w3.org/2001/XMLSchema}string
#
# RETURNS
#   getIssuesFromFilterReturn ArrayOf_tns1_RemoteIssue - {http://localhost:8080/rpc/soap/jirasoapservice-v2}ArrayOf_tns1_RemoteIssue
#
# RAISES
#   fault           RemoteException - {http://exception.rpc.jira.atlassian.com}RemoteException
#
in0 = in1 = nil
puts obj.getIssuesFromFilter(in0, in1)


