# Scott Campbell, Oct 23, 2013
#  Simple way to configure what you would like done with the various
#    notices generated by the mass of isshd data
#
# drop: ACTION_DROP, page: ACTION_PAGE, eadmin: ACTION_EMAIL_ADMIN
#
#@load base/frameworks/notice/actions/drop
#@load base/frameworks/notice/actions/page
#@load base/frameworks/notice/actions/email_admin

module SSHD_ACTION;

export {

	global n_act: table[Notice::Type] of set[Notice::Action];

	# Set of people and places to contact - this can be in conjunction with or as a replacement
	#  for the usual /etc/aliases foo that we end up using
	const EmailList = "" &redef;
	const PageList  = "" &redef;

	# Set values that will be consumed by the action handler
	redef Notice::mail_page_dest = PageList;
	redef Notice::mail_dest = EmailList;

	# Here we set up a default set of Type <-> Action mappings
	# The actual generation of the events is controled in the SSHD_POLICY code
	#
	global ACT_L: set[Notice::Action] = { Notice::ACTION_LOG, } &redef;
	global ACT_E: set[Notice::Action] = { Notice::ACTION_LOG, Notice::ACTION_EMAIL,} &redef;
	global ACT_P: set[Notice::Action] = { Notice::ACTION_LOG, Notice::ACTION_EMAIL, Notice::ACTION_PAGE, } &redef;
	}

event bro_init()
{	
	n_act[SSHD_POLICY::SSHD_RemoteExecHostile]	= ACT_P;
	n_act[SSHD_POLICY::SSHD_Suspicous]		= ACT_E;
	n_act[SSHD_POLICY::SSHD_SuspicousThreshold]	= ACT_E;
	n_act[SSHD_POLICY::SSHD_Hostile]		= ACT_P;
	n_act[SSHD_POLICY::SSHD_BadKey]			= ACT_L;
	n_act[SSHD_POLICY::SSHD_POL_InvalUser]		= ACT_L;
	n_act[SSHD_POLICY::SSHD_POL_AuthPassAtt]	= ACT_L;
	n_act[SSHD_POLICY::SSHD_POL_PassSkip]		= ACT_L;
	n_act[SSHD_POLICY::SSHD_POL_ChanPortOpen]	= ACT_L;
	n_act[SSHD_POLICY::SSHD_POL_ChanPortFwrd]	= ACT_L;
	n_act[SSHD_POLICY::SSHD_POL_ChanPostFwrd]	= ACT_L;
	n_act[SSHD_POLICY::SSHD_POL_ChanSetFwrd]	= ACT_L;
	n_act[SSHD_POLICY::SSHD_POL_Socks4]		= ACT_L;
	n_act[SSHD_POLICY::SSHD_POL_Socks5]		= ACT_L;
	n_act[SSHD_POLICY::SSHD_POL_SesInChanOpen]	= ACT_L;
	n_act[SSHD_POLICY::SSHD_POL_SesNew]		= ACT_L;
	n_act[SSHD_POLICY::SSHD_POL_DirTCPIP]		= ACT_L;
	n_act[SSHD_POLICY::SSHD_POL_TunInit]		= ACT_L;
	n_act[SSHD_POLICY::SSHD_POL_x11fwd]		= ACT_L;
	n_act[SSHD_ANALYZER::SSHD_Hostile]		= ACT_P;
	n_act[SSHD_ANALYZER::SSHD_SuspicousThreshold]	= ACT_E;
	n_act[SSHD_ANALYZER::SSHD_Suspicous]		= ACT_L;
	n_act[SSHD_ANALYZER::SSHD_RemoteExecHostile]	= ACT_P;
}

hook Notice::policy(n: Notice::Info) &priority=6
	{
	if ( n$note in n_act )
		n$actions = n_act[n$note];
	}
