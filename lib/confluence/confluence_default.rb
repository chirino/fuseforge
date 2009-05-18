require 'xsd/qname'

# {http://rpc.confluence.atlassian.com}RemoteException
#class RemoteException < ::StandardError
 # def initialize
  #end
#end

# {http://rpc.confluence.atlassian.com}InvalidSessionException
class InvalidSessionException < ::StandardError
  def initialize
  end
end

# {http://rpc.confluence.atlassian.com}AuthenticationFailedException
class AuthenticationFailedException < ::StandardError
  def initialize
  end
end

# {http://rpc.confluence.atlassian.com}AlreadyExistsException
class AlreadyExistsException < ::StandardError
  def initialize
  end
end

# {http://rpc.confluence.atlassian.com}NotPermittedException
class NotPermittedException < ::StandardError
  def initialize
  end
end

# {http://rpc.confluence.atlassian.com}VersionMismatchException
class VersionMismatchException < ::StandardError
  def initialize
  end
end

# {http://beans.soap.rpc.confluence.atlassian.com}RemoteSearchResult
#   excerpt - SOAP::SOAPString
#   id - SOAP::SOAPLong
#   title - SOAP::SOAPString
#   type - SOAP::SOAPString
#   url - SOAP::SOAPString
class RemoteSearchResult
  attr_accessor :excerpt
  attr_accessor :id
  attr_accessor :title
  attr_accessor :type
  attr_accessor :url

  def initialize(excerpt = nil, id = nil, title = nil, type = nil, url = nil)
    @excerpt = excerpt
    @id = id
    @title = title
    @type = type
    @url = url
  end
end

# {http://beans.soap.rpc.confluence.atlassian.com}RemoteSpaceSummary
#   key - SOAP::SOAPString
#   name - SOAP::SOAPString
#   type - SOAP::SOAPString
#   url - SOAP::SOAPString
class RemoteSpaceSummary
  attr_accessor :key
  attr_accessor :name
  attr_accessor :type
  attr_accessor :url

  def initialize(key = nil, name = nil, type = nil, url = nil)
    @key = key
    @name = name
    @type = type
    @url = url
  end
end

# {http://beans.soap.rpc.confluence.atlassian.com}RemoteSpace
#   key - SOAP::SOAPString
#   name - SOAP::SOAPString
#   type - SOAP::SOAPString
#   url - SOAP::SOAPString
#   description - SOAP::SOAPString
#   homePage - SOAP::SOAPLong
#   spaceGroup - SOAP::SOAPString
class RemoteSpace < RemoteSpaceSummary
  attr_accessor :key
  attr_accessor :name
  attr_accessor :type
  attr_accessor :url
  attr_accessor :description
  attr_accessor :homePage
  attr_accessor :spaceGroup

  def initialize(key = nil, name = nil, type = nil, url = nil, description = nil, homePage = nil, spaceGroup = nil)
    @key = key
    @name = name
    @type = type
    @url = url
    @description = description
    @homePage = homePage
    @spaceGroup = spaceGroup
  end
end

# {http://beans.soap.rpc.confluence.atlassian.com}RemoteComment
#   content - SOAP::SOAPString
#   created - SOAP::SOAPDateTime
#   creator - SOAP::SOAPString
#   id - SOAP::SOAPLong
#   modified - SOAP::SOAPDateTime
#   modifier - SOAP::SOAPString
#   pageId - SOAP::SOAPLong
#   parentId - SOAP::SOAPLong
#   title - SOAP::SOAPString
#   url - SOAP::SOAPString
class RemoteComment
  attr_accessor :content
  attr_accessor :created
  attr_accessor :creator
  attr_accessor :id
  attr_accessor :modified
  attr_accessor :modifier
  attr_accessor :pageId
  attr_accessor :parentId
  attr_accessor :title
  attr_accessor :url

  def initialize(content = nil, created = nil, creator = nil, id = nil, modified = nil, modifier = nil, pageId = nil, parentId = nil, title = nil, url = nil)
    @content = content
    @created = created
    @creator = creator
    @id = id
    @modified = modified
    @modifier = modifier
    @pageId = pageId
    @parentId = parentId
    @title = title
    @url = url
  end
end

# {http://beans.soap.rpc.confluence.atlassian.com}RemoteServerInfo
#   baseUrl - SOAP::SOAPString
#   buildId - SOAP::SOAPString
#   developmentBuild - SOAP::SOAPBoolean
#   majorVersion - SOAP::SOAPInt
#   minorVersion - SOAP::SOAPInt
#   patchLevel - SOAP::SOAPInt
class RemoteServerInfo
  attr_accessor :baseUrl
  attr_accessor :buildId
  attr_accessor :developmentBuild
  attr_accessor :majorVersion
  attr_accessor :minorVersion
  attr_accessor :patchLevel

  def initialize(baseUrl = nil, buildId = nil, developmentBuild = nil, majorVersion = nil, minorVersion = nil, patchLevel = nil)
    @baseUrl = baseUrl
    @buildId = buildId
    @developmentBuild = developmentBuild
    @majorVersion = majorVersion
    @minorVersion = minorVersion
    @patchLevel = patchLevel
  end
end

# {http://beans.soap.rpc.confluence.atlassian.com}AbstractRemotePageSummary
# abstract
#   id - SOAP::SOAPLong
#   permissions - SOAP::SOAPInt
#   space - SOAP::SOAPString
#   title - SOAP::SOAPString
#   url - SOAP::SOAPString
class AbstractRemotePageSummary
  attr_accessor :id
  attr_accessor :permissions
  attr_accessor :space
  attr_accessor :title
  attr_accessor :url

  def initialize(id = nil, permissions = nil, space = nil, title = nil, url = nil)
    @id = id
    @permissions = permissions
    @space = space
    @title = title
    @url = url
  end
end

# {http://beans.soap.rpc.confluence.atlassian.com}RemotePageSummary
#   id - SOAP::SOAPLong
#   permissions - SOAP::SOAPInt
#   space - SOAP::SOAPString
#   title - SOAP::SOAPString
#   url - SOAP::SOAPString
#   parentId - SOAP::SOAPLong
class RemotePageSummary < AbstractRemotePageSummary
  attr_accessor :id
  attr_accessor :permissions
  attr_accessor :space
  attr_accessor :title
  attr_accessor :url
  attr_accessor :parentId

  def initialize(id = nil, permissions = nil, space = nil, title = nil, url = nil, parentId = nil)
    @id = id
    @permissions = permissions
    @space = space
    @title = title
    @url = url
    @parentId = parentId
  end
end

# {http://beans.soap.rpc.confluence.atlassian.com}RemotePage
#   id - SOAP::SOAPLong
#   permissions - SOAP::SOAPInt
#   space - SOAP::SOAPString
#   title - SOAP::SOAPString
#   url - SOAP::SOAPString
#   parentId - SOAP::SOAPLong
#   content - SOAP::SOAPString
#   contentStatus - SOAP::SOAPString
#   created - SOAP::SOAPDateTime
#   creator - SOAP::SOAPString
#   current - SOAP::SOAPBoolean
#   homePage - SOAP::SOAPBoolean
#   modified - SOAP::SOAPDateTime
#   modifier - SOAP::SOAPString
#   version - SOAP::SOAPInt
class RemotePage < RemotePageSummary
  attr_accessor :id
  attr_accessor :permissions
  attr_accessor :space
  attr_accessor :title
  attr_accessor :url
  attr_accessor :parentId
  attr_accessor :content
  attr_accessor :contentStatus
  attr_accessor :created
  attr_accessor :creator
  attr_accessor :current
  attr_accessor :homePage
  attr_accessor :modified
  attr_accessor :modifier
  attr_accessor :version

  def initialize(id = nil, permissions = nil, space = nil, title = nil, url = nil, parentId = nil, content = nil, contentStatus = nil, created = nil, creator = nil, current = nil, homePage = nil, modified = nil, modifier = nil, version = nil)
    @id = id
    @permissions = permissions
    @space = space
    @title = title
    @url = url
    @parentId = parentId
    @content = content
    @contentStatus = contentStatus
    @created = created
    @creator = creator
    @current = current
    @homePage = homePage
    @modified = modified
    @modifier = modifier
    @version = version
  end
end

# {http://beans.soap.rpc.confluence.atlassian.com}RemoteBlogEntrySummary
#   id - SOAP::SOAPLong
#   permissions - SOAP::SOAPInt
#   space - SOAP::SOAPString
#   title - SOAP::SOAPString
#   url - SOAP::SOAPString
#   author - SOAP::SOAPString
#   publishDate - SOAP::SOAPDateTime
class RemoteBlogEntrySummary < AbstractRemotePageSummary
  attr_accessor :id
  attr_accessor :permissions
  attr_accessor :space
  attr_accessor :title
  attr_accessor :url
  attr_accessor :author
  attr_accessor :publishDate

  def initialize(id = nil, permissions = nil, space = nil, title = nil, url = nil, author = nil, publishDate = nil)
    @id = id
    @permissions = permissions
    @space = space
    @title = title
    @url = url
    @author = author
    @publishDate = publishDate
  end
end

# {http://beans.soap.rpc.confluence.atlassian.com}RemoteBlogEntry
#   id - SOAP::SOAPLong
#   permissions - SOAP::SOAPInt
#   space - SOAP::SOAPString
#   title - SOAP::SOAPString
#   url - SOAP::SOAPString
#   author - SOAP::SOAPString
#   publishDate - SOAP::SOAPDateTime
#   content - SOAP::SOAPString
#   version - SOAP::SOAPInt
class RemoteBlogEntry < RemoteBlogEntrySummary
  attr_accessor :id
  attr_accessor :permissions
  attr_accessor :space
  attr_accessor :title
  attr_accessor :url
  attr_accessor :author
  attr_accessor :publishDate
  attr_accessor :content
  attr_accessor :version

  def initialize(id = nil, permissions = nil, space = nil, title = nil, url = nil, author = nil, publishDate = nil, content = nil, version = nil)
    @id = id
    @permissions = permissions
    @space = space
    @title = title
    @url = url
    @author = author
    @publishDate = publishDate
    @content = content
    @version = version
  end
end

# {http://beans.soap.rpc.confluence.atlassian.com}RemoteUser
#   email - SOAP::SOAPString
#   fullname - SOAP::SOAPString
#   name - SOAP::SOAPString
#   url - SOAP::SOAPString
#changed by sanjay
class ConfluenceRemoteUser
  attr_accessor :email
  attr_accessor :fullname
  attr_accessor :name
  attr_accessor :url

  def initialize(email = nil, fullname = nil, name = nil, url = nil)
    @email = email
    @fullname = fullname
    @name = name
    @url = url
  end
end

# {http://beans.soap.rpc.confluence.atlassian.com}RemoteClusterInformation
#   description - SOAP::SOAPString
#   memberCount - SOAP::SOAPInt
#   members - ArrayOf_xsd_anyType
#   multicastAddress - SOAP::SOAPString
#   multicastPort - SOAP::SOAPString
#   name - SOAP::SOAPString
#   running - SOAP::SOAPBoolean
class RemoteClusterInformation
  attr_accessor :description
  attr_accessor :memberCount
  attr_accessor :members
  attr_accessor :multicastAddress
  attr_accessor :multicastPort
  attr_accessor :name
  attr_accessor :running

  def initialize(description = nil, memberCount = nil, members = nil, multicastAddress = nil, multicastPort = nil, name = nil, running = nil)
    @description = description
    @memberCount = memberCount
    @members = members
    @multicastAddress = multicastAddress
    @multicastPort = multicastPort
    @name = name
    @running = running
  end
end

# {http://beans.soap.rpc.confluence.atlassian.com}RemoteAttachment
#   comment - SOAP::SOAPString
#   contentType - SOAP::SOAPString
#   created - SOAP::SOAPDateTime
#   creator - SOAP::SOAPString
#   fileName - SOAP::SOAPString
#   fileSize - SOAP::SOAPLong
#   id - SOAP::SOAPLong
#   pageId - SOAP::SOAPLong
#   title - SOAP::SOAPString
#   url - SOAP::SOAPString
#changed by sanjaymk
class ConfluenceRemoteAttachment
  attr_accessor :comment
  attr_accessor :contentType
  attr_accessor :created
  attr_accessor :creator
  attr_accessor :fileName
  attr_accessor :fileSize
  attr_accessor :id
  attr_accessor :pageId
  attr_accessor :title
  attr_accessor :url

  def initialize(comment = nil, contentType = nil, created = nil, creator = nil, fileName = nil, fileSize = nil, id = nil, pageId = nil, title = nil, url = nil)
    @comment = comment
    @contentType = contentType
    @created = created
    @creator = creator
    @fileName = fileName
    @fileSize = fileSize
    @id = id
    @pageId = pageId
    @title = title
    @url = url
  end
end

# {http://beans.soap.rpc.confluence.atlassian.com}RemoteContentPermission
#   groupName - SOAP::SOAPString
#   type - SOAP::SOAPString
#   userName - SOAP::SOAPString
class RemoteContentPermission
  attr_accessor :groupName
  attr_accessor :type
  attr_accessor :userName

  def initialize(groupName = nil, type = nil, userName = nil)
    @groupName = groupName
    @type = type
    @userName = userName
  end
end

# {http://beans.soap.rpc.confluence.atlassian.com}RemoteContentPermissionSet
#   contentPermissions - ArrayOf_tns2_RemoteContentPermission
#   type - SOAP::SOAPString
class RemoteContentPermissionSet
  attr_accessor :contentPermissions
  attr_accessor :type

  def initialize(contentPermissions = nil, type = nil)
    @contentPermissions = contentPermissions
    @type = type
  end
end

# {http://beans.soap.rpc.confluence.atlassian.com}RemoteLabel
#   id - SOAP::SOAPLong
#   name - SOAP::SOAPString
#   namespace - SOAP::SOAPString
#   owner - SOAP::SOAPString
class RemoteLabel
  attr_accessor :id
  attr_accessor :name
  attr_accessor :namespace
  attr_accessor :owner

  def initialize(id = nil, name = nil, namespace = nil, owner = nil)
    @id = id
    @name = name
    @namespace = namespace
    @owner = owner
  end
end

# {http://beans.soap.rpc.confluence.atlassian.com}RemoteSpaceGroup
#   creatorName - SOAP::SOAPString
#   key - SOAP::SOAPString
#   licenseKey - SOAP::SOAPString
#   name - SOAP::SOAPString
class RemoteSpaceGroup
  attr_accessor :creatorName
  attr_accessor :key
  attr_accessor :licenseKey
  attr_accessor :name

  def initialize(creatorName = nil, key = nil, licenseKey = nil, name = nil)
    @creatorName = creatorName
    @key = key
    @licenseKey = licenseKey
    @name = name
  end
end

# {http://beans.soap.rpc.confluence.atlassian.com}RemotePageHistory
#   id - SOAP::SOAPLong
#   modified - SOAP::SOAPDateTime
#   modifier - SOAP::SOAPString
#   version - SOAP::SOAPInt
class RemotePageHistory
  attr_accessor :id
  attr_accessor :modified
  attr_accessor :modifier
  attr_accessor :version

  def initialize(id = nil, modified = nil, modifier = nil, version = nil)
    @id = id
    @modified = modified
    @modifier = modifier
    @version = version
  end
end

# {http://beans.soap.rpc.confluence.atlassian.com}RemotePageUpdateOptions
#   minorEdit - SOAP::SOAPBoolean
#   versionComment - SOAP::SOAPString
class RemotePageUpdateOptions
  attr_accessor :minorEdit
  attr_accessor :versionComment

  def initialize(minorEdit = nil, versionComment = nil)
    @minorEdit = minorEdit
    @versionComment = versionComment
  end
end

# {http://beans.soap.rpc.confluence.atlassian.com}RemoteUserInformation
#   content - SOAP::SOAPString
#   creationDate - SOAP::SOAPDateTime
#   creatorName - SOAP::SOAPString
#   id - SOAP::SOAPLong
#   lastModificationDate - SOAP::SOAPDateTime
#   lastModifierName - SOAP::SOAPString
#   username - SOAP::SOAPString
#   version - SOAP::SOAPInt
class RemoteUserInformation
  attr_accessor :content
  attr_accessor :creationDate
  attr_accessor :creatorName
  attr_accessor :id
  attr_accessor :lastModificationDate
  attr_accessor :lastModifierName
  attr_accessor :username
  attr_accessor :version

  def initialize(content = nil, creationDate = nil, creatorName = nil, id = nil, lastModificationDate = nil, lastModifierName = nil, username = nil, version = nil)
    @content = content
    @creationDate = creationDate
    @creatorName = creatorName
    @id = id
    @lastModificationDate = lastModificationDate
    @lastModifierName = lastModifierName
    @username = username
    @version = version
  end
end

# {http://beans.soap.rpc.confluence.atlassian.com}RemoteNodeStatus
#   jVMstats - Map
#   buildStats - Map
#   nodeId - SOAP::SOAPInt
#   props - Map
class RemoteNodeStatus
  attr_accessor :jVMstats
  attr_accessor :buildStats
  attr_accessor :nodeId
  attr_accessor :props

  def initialize(jVMstats = nil, buildStats = nil, nodeId = nil, props = nil)
    @jVMstats = jVMstats
    @buildStats = buildStats
    @nodeId = nodeId
    @props = props
  end
end

# {http://beans.soap.rpc.confluence.atlassian.com}RemotePermission
#   lockType - SOAP::SOAPString
#   lockedBy - SOAP::SOAPString
class RemotePermission
  attr_accessor :lockType
  attr_accessor :lockedBy

  def initialize(lockType = nil, lockedBy = nil)
    @lockType = lockType
    @lockedBy = lockedBy
  end
end

# {http://xml.apache.org/xml-soap}mapItem
#   key - (any)
#   value - (any)
class MapItem
  attr_accessor :key
  attr_accessor :value

  def initialize(key = nil, value = nil)
    @key = key
    @value = value
  end
end

# {http://xml.apache.org/xml-soap}Vector
class Vector < ::Array
end

# {http://confluence.atlassian.com/rpc/soap-axis/confluenceservice-v1}ArrayOf_xsd_string
class ArrayOf_xsd_string < ::Array
end

# {http://confluence.atlassian.com/rpc/soap-axis/confluenceservice-v1}ArrayOf_tns2_RemoteSearchResult
class ArrayOf_tns2_RemoteSearchResult < ::Array
end

# {http://confluence.atlassian.com/rpc/soap-axis/confluenceservice-v1}ArrayOf_tns2_RemotePageSummary
class ArrayOf_tns2_RemotePageSummary < ::Array
end

# {http://confluence.atlassian.com/rpc/soap-axis/confluenceservice-v1}ArrayOf_xsd_anyType
class ArrayOf_xsd_anyType < ::Array
end

# {http://confluence.atlassian.com/rpc/soap-axis/confluenceservice-v1}ArrayOf_tns2_RemoteComment
class ArrayOf_tns2_RemoteComment < ::Array
end

#changed by sanjaymk from RemoteAttachment to ConfluenceRemoteAttachment
# {http://confluence.atlassian.com/rpc/soap-axis/confluenceservice-v1}ArrayOf_tns2_RemoteAttachment
class ArrayOf_tns2_ConfluenceRemoteAttachment < ::Array
end

# {http://confluence.atlassian.com/rpc/soap-axis/confluenceservice-v1}ArrayOf_tns2_RemoteContentPermission
class ArrayOf_tns2_RemoteContentPermission < ::Array
end

# {http://confluence.atlassian.com/rpc/soap-axis/confluenceservice-v1}ArrayOf_tns2_RemoteContentPermissionSet
class ArrayOf_tns2_RemoteContentPermissionSet < ::Array
end

# {http://confluence.atlassian.com/rpc/soap-axis/confluenceservice-v1}ArrayOf_tns2_RemoteLabel
class ArrayOf_tns2_RemoteLabel < ::Array
end

# {http://confluence.atlassian.com/rpc/soap-axis/confluenceservice-v1}ArrayOf_tns2_RemoteSpaceSummary
class ArrayOf_tns2_RemoteSpaceSummary < ::Array
end

# {http://confluence.atlassian.com/rpc/soap-axis/confluenceservice-v1}ArrayOf_tns2_RemoteSpaceGroup
class ArrayOf_tns2_RemoteSpaceGroup < ::Array
end

# {http://confluence.atlassian.com/rpc/soap-axis/confluenceservice-v1}ArrayOf_tns2_RemoteSpace
class ArrayOf_tns2_RemoteSpace < ::Array
end

# {http://confluence.atlassian.com/rpc/soap-axis/confluenceservice-v1}ArrayOf_tns2_RemotePageHistory
class ArrayOf_tns2_RemotePageHistory < ::Array
end

# {http://confluence.atlassian.com/rpc/soap-axis/confluenceservice-v1}ArrayOf_tns2_RemoteBlogEntrySummary
class ArrayOf_tns2_RemoteBlogEntrySummary < ::Array
end

# {http://confluence.atlassian.com/rpc/soap-axis/confluenceservice-v1}ArrayOf_tns2_RemoteNodeStatus
class ArrayOf_tns2_RemoteNodeStatus < ::Array
end

# {http://confluence.atlassian.com/rpc/soap-axis/confluenceservice-v1}ArrayOf_tns2_RemotePermission
class ArrayOf_tns2_RemotePermission < ::Array
end
