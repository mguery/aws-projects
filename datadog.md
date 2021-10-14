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
- [My Fargate notes](https://github.com/mguery/aws-projects/blob/main/fargate.md)
- [ECS Container Insights](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-metrics-ECS.html)

### Memory metrics

Your ECS task definitions designate the minimum available and maximum allowable amounts of memory for your workload to use. Monitoring the memory usage of your tasks and pods can help you understand whether you’ve specified an appropriate range of memory to be used by your workloads.
- Underprovisioned resources, your cluster may not perform well due to resource constraints
- Overprovisioned resources, you could end up paying more for Fargate than necessary

ECS memory utilization - The amount of memory used by tasks in the cluster, in bytes	
- Metric type - Resource: Utilization

ECS memory reservation - The amount of memory reserved by tasks in the cluster, in bytes	
- Metric type - Resource: Other

Metric to alert on
- Memory utilization - By monitoring the memory utilization of your ECS tasks, you can determine whether any of the memory in your Fargate compute resources is going unused. If your workload is consistently using less than its minimum memory allocation, you should consider reducing the "memoryReservation" value specified (or the memory value if you haven’t specified memoryReservation) in the ECS task definition. You can also create an alert to proactively notify you if your tasks' memory utilization approaches the available limit. (Creating an alert that triggers when your application reaches 80 percent memory utilization will give you enough time to raise the limit or troubleshoot the containerized application before your workload suffers an out-of-memory (OOM) error.)

### CPU metrics

Your ECS task definitions include an amount of CPU to be used by each task and, optionally, by each container in your workloads. The size of the compute resource Fargate launches is based on the resources you designate for your tasks and containers, so it’s important to monitor CPU utilization to ensure that you’ve designated the right amount of CPU resources for your workloads.

ECS CPU utilization	- The number of CPU units used by running tasks in the cluster	
- Metric type - Resource: Utilization

ECS CPU reservation	- The number of CPU units reserved by running tasks in the cluster
- Metric type - Resource: Other

Metric to alert on
- CPU utilization - You should monitor CPU utilization to ensure that any spikes in your workload won’t breach your defined CPU limits. If you create an alert that triggers when your tasks or pods consume more than 90 percent of available CPU, you can prevent throttling, which could slow down your application. You can also alert on low CPU utilization to reduce costs. If it’s consistently below 50 percent, you should consider revising your task definition or container spec to decrease the number of CPU units you’re specifying, which can help you avoid paying for unused resources.

### Cluster state metrics

Cluster state metrics convey how busy your cluster is and help you monitor the lifecycle of your tasks. You can use the following metrics to monitor your cluster’s performance and resource utilization, and to spot any workloads that should be running but aren’t.

ECS current task count - The number of tasks in the cluster currently in the desired, running, or pending state	
- Metric type - Other

ECS service count - The number of services currently running in the cluster
- Metric type - Other

Metric to alert on: 
- Current count of tasks and pods - AWS enforces a quota that limits the number of tasks and pods you can run concurrently: the number of ECS tasks you’re running on Fargate plus the number of EKS pods you’re running on Fargate can’t exceed 100 per region. You should create an alert to notify you if the combined count of Fargate tasks (ECS) and pods (EKS) approaches this limit so you can evaluate your need for new and existing workloads and avoid errors launching new pods.
- Desired task/pod count vs. current task/pod count - If you have an error in the YAML file that defines your pod, for example, EKS will return an error and your pod won’t be created. Comparing the desired counts of your tasks or pods against the current count lets you spot any disparities before they affect the functionality of your application. 


---

Resources
- [Learn Datadog](https://learn.datadoghq.com)
- [Docs](https://docs.datadoghq.com/)
- [Distributed Monitoring 101: the “Four Golden Signals”](https://medium.com/forepaas/distributed-monitoring-101-the-four-golden-signals-305bbbc33d35)
- [Resilience First: SRE and the Four Golden Signals of Monitoring](https://www.splunk.com/en_us/observability/resources/guide-to-sre-and-the-four-golden-signals-of-monitoring.html)



