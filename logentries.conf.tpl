
#Note: currently, do not use this source, we will use s_src from main config
#source s_log {
#	system();	# Check which OS & collect system logs
#	internal();	# Collect syslog-ng logs
#};

template logentriesTemplate {
      template("{{ LOGENTRIES_TOKEN }} $ISODATE $HOST $MSG\n");
      template_escape(no);
};

destination d_network_logentries {
      tcp("data.logentries.com" port(80) template(logentriesTemplate));
};

log {
	source(s_src);
	destination(d_network_logentries);
};
### END Syslog-ng Logging Directives for logentries.com ###
