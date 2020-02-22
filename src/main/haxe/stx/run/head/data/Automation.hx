package stx.run.head.data;

import stx.proxy.core.head.data.Proxy in ProxyT;

typedef Automation = ProxyT<JobQueue,Noise,Noise,JobQueue,JobQueue,AutomationFailure<Dynamic>>;