## Controller Python Script "sendto"
##bind container=container
##bind context=context
##bind namespace=
##bind script=script
##bind state=state
##bind subpath=traverse_subpath
##parameters=
##title=Send an URL to a friend
##
REQUEST=context.REQUEST

from Products.CMFPlone import transaction_note
from Products.CMFCore.utils import getToolByName
from ZODB.POSException import ConflictError

plone_utils=context.plone_utils
site_properties=context.portal_properties.site_properties

# need to check visible state of 'sendto' action in portal_actions
# but I couldn't figure out how - update collector issue #1490
# when implemented
at = getToolByName(context, 'portal_actions')

#if not sendto_action.visible :
if 0:
    return state.set(status='failure', portal_status_message='You are not allowed to send this link.')

variables = { 'send_from_address' : REQUEST.send_from_address
            , 'send_to_address'   : REQUEST.send_to_address
            , 'url'               : context.absolute_url()
            , 'title'             : context.Title()
            , 'description'       : context.description
            , 'comment'           : REQUEST.get('comment',None)
            }
try:
    plone_utils.sendto( variables )
except ConflictError:
    raise
except: #XXX To many things could possibly go wrong. So we catch all.
    exception = context.plone_utils.exceptionString()
    return state.set(status='failure', portal_status_message=exception)

tmsg='Sent page %s to %s' % (context.absolute_url(), REQUEST.send_to_address)
transaction_note(tmsg)

return state.set(portal_status_message='Mail sent.')
