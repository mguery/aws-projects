# Datadog 

Cloud monitoring as a service. Monitoring and analytics platform.

**Features + use cases**

Cloud migration, DevOps, security analytics, hybrid cloud and on-prem monitoring, infras monitoring, database monitoring, log management, incident management

## Platform

[Datadog Agent](https://docs.datadoghq.com/agent) - The Datadog Agent is software that runs on your hosts. It collects events and metrics from hosts and sends them to Datadog, where you can analyze your monitoring and performance data. 

[Example for Amazon Linux 2](https://docs.datadoghq.com/agent/basic_agent_usage/amazonlinux/?tab=agentv6v7):
- `DD_AGENT_MAJOR_VERSION=7 DD_API_KEY=f73ce9e293ed0fdbf29fbacfa6bc8d3b DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"`
- Start Agent as a service	`sudo systemctl start datadog-agent`
- Stop Agent running as a service	`sudo systemctl stop datadog-agent`
- Other commands - restart, status, help - `sudo datadog-agent --help`

[Integrations](https://docs.datadoghq.com/getting_started/integrations/) - Use integrations to bring together all of the metrics and logs from your infrastructure and gain insight into the unified system as a whole—you can see pieces individually and also how individual pieces are impacting the whole.

Datadog provides three main types of integrations:
- Agent-based integrations are installed with the Datadog Agent and use a Python class method called check to define the metrics to collect.
- Authentication (crawler) based integrations are set up in Datadog where you provide credentials for obtaining metrics with the API. These include popular integrations like Slack, [AWS](https://docs.datadoghq.com/integrations/amazon_web_services/?tab=roledelegation#setup), Azure, and PagerDuty.
- Library integrations use the Datadog API to allow you to monitor applications based on the language they are written in, like Node.js or Python.

[Dashboards](https://docs.datadoghq.com/dashboards/) - A dashboard is Datadog’s tool for visually tracking, analyzing, and displaying key performance metrics, which enable you to monitor the health of your infrastructure.



## ECS Fargate: Key Metrics to Monitor

Links 
- https://www.datadoghq.com/blog/aws-fargate-metrics
- https://docs.datadoghq.com/integrations/ecs_fargate/?tab=fluentbitandfirelens

### Memory metrics

Your ECS task definitions designate the minimum available and maximum allowable amounts of memory for your workload to use.

Monitoring the memory usage of your tasks and pods can help you understand whether you’ve specified an appropriate range of memory to be used by your workloads.
- Underprovisioned resources, your cluster may not perform well due to resource constraints
- Overprovisioned resources, you could end up paying more for Fargate than necessary

ECS memory utilization - The amount of memory used by tasks in the cluster, in bytes	
- Metric type - Resource: Utilization

Metric to alert on
- Memory utilization

### CPU metrics

Your ECS task definitions include an amount of CPU to be used by each task and, optionally, by each container in your workloads. 

The size of the compute resource Fargate launches is based on the resources you designate for your tasks and containers, so it’s important to monitor CPU utilization to ensure that you’ve designated the right amount of CPU resources for your workloads.

ECS CPU utilization	- The number of CPU units used by running tasks in the cluster	
- Metric type - Resource: Utilization

Metric to alert on
- CPU utilization

### Cluster state metrics

Cluster state metrics convey how busy your cluster is and help you monitor the lifecycle of your tasks.

ECS current task count - The number of tasks in the cluster currently in the desired, running, or pending state	
- Metric type - Other

ECS service count - The number of services currently running in the cluster
- Metric type - Other

Metric to alert on: 
- Current count of tasks
- Desired task/pod count vs. current task/pod count


---

Resources
- [Learn Datadog](https://learn.datadoghq.com)
- [Docs](https://docs.datadoghq.com/)
