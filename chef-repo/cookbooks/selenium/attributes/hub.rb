default['selenium']['hub']['service_name'] = 'selenium_hub' # used by hub recipe only
default['selenium']['hub']['host'] = 'null'
default['selenium']['hub']['port'] = 4444
default['selenium']['hub']['jvm_args'] = nil
default['selenium']['hub']['newSessionWaitTimeout'] = -1
default['selenium']['hub']['servlets'] = []
default['selenium']['hub']['prioritizer'] = 'null'
default['selenium']['hub']['capabilityMatcher'] = 'org.openqa.grid.internal.utils.DefaultCapabilityMatcher'
default['selenium']['hub']['throwOnCapabilityNotPresent'] = true
default['selenium']['hub']['nodePolling'] = 5000
default['selenium']['hub']['cleanUpCycle'] = 5000
default['selenium']['hub']['timeout'] = 30_000
default['selenium']['hub']['browserTimeout'] = 0
default['selenium']['hub']['maxSession'] = 5
default['selenium']['hub']['jettyMaxThreads'] = -1
