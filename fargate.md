# AWS Fargate
Serverless containers. No provisioning or EC2 instances to manage, just focus on your apps. Runs containers based on what you need (CPU, RAM). Monitor apps with CloudWatch Container Insights. Secure within your own VPC. ECS tasks run in own runtime environment. Pay for requested resources when used. 

With Fargate, you build container image -> define mem and compute resources req'd -> run and manage applications 

**Use cases** - microservices - run apps as independent components, batch processing - package batches and ETL jobs into containers, plus, machine learning, app migration, PaaS (build containers with devs to manage infrastructure)

1. **Containers** - packages of source code together with the required libraries, frameworks, dependencies, and configurations.
2. **Cluster** - EC2 instances inside Docker containers. Empty ECS cluster is created and then launch tasks as Fargate.
3. **Task Definition** - Blueprint of your app. A JSON file defines the configuration of up to 10 containers. Specify CPU and memory.
4. **Task** - Launches containers defined in task def. Put container image inside task.
5. **Service** - Ensures tasks remain running. Launches # of tasks/containers from task def. and maintains them

## Load Balancing for Fargate

- A task has 1 unique IP. 
- Service is exposed via a LB. LB directs traffic to tasks of the service. 
- Service can run behind a LB to distribute traffice across its tasks. 
- Fargate launch type requires awsvpc network mode. This mode provides a Elastic Network Interface for each task. Specify the subnets and security groups. ENI should be attached.
- Tasks in public subnet gets a public IP. Tasks in private subnet uses NAT Gateway to access the internet and pull Docker images to run containers.
- LB is single PoC for all outside traffic. To configure a LB, you need to create traget groups. TG can have targets of types of instance or IP address. 
- LB has listeners configured with port and protocol. It also has rules that will direct rtraffic to target groups if matched. 

**Autoscaling** - Containers run in Fargate -> Service metrics in CloudWatch -> CW alarms -> Autoscaling policy -> ECS responds to policy -> another container launches in Fargate

Templates to add autoscaling to your service (From containersonaws.com. Clicking below automatically downloads file to desktop)
- [Scale service up and down based on CPU usage](https://s3.amazonaws.com/us-east-1-containersonaws.com/templates/autoscaling/scale-service-by-cpu.yml)
- [Scale service up and down based on memory usage](https://s3.amazonaws.com/us-east-1-containersonaws.com/templates/autoscaling/scale-service-by-memory.yml)

## Configure ECS Service on Fargate (Application Load Balancer + Autoscaling)
1. From [ECS page](https://us-east-2.console.aws.amazon.com/ecs), Create cluster
2. Select cluster template - Networking only, Next step
3. Cluster name. Leave box unchecked to use existing/default VPC, Optional - check Container Insights, then click Create
4. Click Task def. on sidebar. Create new task def., select Fargate launch type, next step
5. Add task def. name. Choose role. (Best way to give tasks the perms to interact with resources)
6. Task size - choose memory and CPU
7. Under Container Definitions, click Add container - Container name, image url, memory limits, port mappings (forwarding to, ex. exposed port from Dockerfile), click Add
8. Create, View task definition
9. From [EC2 page](https://us-east-2.console.aws.amazon.com/ec2), click Load balancing on sidebar. Create LB
10. Select Application Load Balancer. 
  - Name, Scheme - internet-facing
  - Listeners - HTTP & Port 80
  - If working with certificates, HTTPS & Port 443
  - Under AZs, choose VPC, AZs, subnets (min. of 2 subnets required)
  - Next: configure security settings
11. Create or select existing security group (ex. TCP, 80, custom, 0.0.0.0/0, ::/0). Next: configure routing
12. Target group - New target group, name, Target type - IP, Protocol - HTTP, Port - (forwarding, ex. exposed port in Dockerfile), Next: register targets
13. Next: Review, Create. Wait for Active state.
14. From Clusters page - under Services tab, create
15. Launch type - Fargate, select Task definition and Platform version, Service name, Number of tasks (the minimum # of tasks to run at all times), make additional changes or leave default settings. Click Next step
16. Select VPC, subnets (same ones used with load balancer), Security groups, Auto-assign public IP - ENABLED. 
17. Load balancing section - select ALB and LB name. 
18. Container - Select container and click Add to Load balancer. Select Target group name.
19. Set Auto Scaling: [How to configure Service Auto Scaling to adjust your service's desired count](https://aws.amazon.com/premiumsupport/knowledge-center/ecs-fargate-service-auto-scaling). Next step. Create Service.
20. Last status & Desired status should be Running.
22. Note: If status is still not running - From your cluster, under Details tab, click the security group link. Create new inbound rule - All TCP, Source - select security group of load balancer, Save rules. (This makes sure the security group for the Fargate app has perms to receive connection from the LB.)
23. Copy and paste DNS name from LB in browser to test connection

To delete cluster, use old AWS console. Then click each task def. to deregister

Notes
- 

Resources
- [Deep Dive on Amazon ECS Cluster Auto Scaling](https://aws.amazon.com/blogs/containers/deep-dive-on-amazon-ecs-cluster-auto-scaling/)
- [Video: How to work with AWS ECS Fargate with Auto Scaling](https://youtu.be/cW0555857M0)


---

## CodeDeploy, Fargate, Auto scaling

From [AWS CodeDeploy | DevOps With AWS Part 3](https://www.linkedin.com/pulse/aws-codedeploy-devops-part-3-sandip-das)

### Minimize downtime

- **Rolling and Blue/Green updates** - Applications do not require downtime when they’re being upgraded to a new revision with AWS CodeDeploy. AWS CodeDeploy can perform blue/green deployments to Amazon EC2 instances, an Amazon ECS service (both EC2 and AWS Fargate launch type), or an AWS Lambda function. With a blue/green deployment, the new version of your application is launched alongside the old version. Once the new revision is tested and declared ready, CodeDeploy can shift the traffic from your prior version to your new version according to your specifications.

CodeDeploy can also perform a rolling update across a group of Amazon EC2 instances where only a fraction of the instances are taken offline at any one time. CodeDeploy progressively works its way across the instances allowing applications to remain available and continue serving traffic. For AWS Lambda functions, incoming traffic is gradually routed from the old version to the new one.

---

**ECS Deployment Types**

- [Rolling update](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/deployment-type-ecs.html)
- [External deployment](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/deployment-type-external.html)
- **[Blue/Green deployment with CodeDeploy](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/deployment-type-bluegreen.html)**
  - This deployment type enables you to verify a new deployment of a service before sending production traffic to it. Three ways traffic can shift during a blue/green deployment:
    - Canary — Traffic is shifted in two increments. You can choose from predeﬁned canary options that specify the percentage of traﬃc shifted to your updated task set in the ﬁrst increment and the interval, in minutes, before the remaining traﬃc is shifted in the second increment.
    - Linear — Traffic is shifted in equal increments with an equal number of minutes between each increment.
    - All-at-once — All traffic is shifted from the original task set to the updated task set all at once.
  - [Perform ECS blue/green deployments through CodeDeploy using AWS CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/blue-green.html)
    - Blue/green deployments are a safe deployment strategy provided by CodeDeploy for minimizing interruptions caused by changing application versions. This is accomplished by creating your new application environment, referred to as green, alongside your current application that's serving your live traffic, referred to as blue. 
    - To perform ECS blue/green deployments, you start by creating a stack template that defines the resources for both your blue and green application environments, including specifying the traffic routing and stabilization settings to use.
    - To enable CloudFormation to perform blue/green deployments on a stack, include the following information in its stack template:
      - A `Transform` section in your template that invokes the AWS::CodeDeployBlueGreen transform and a Hook section that invokes the AWS::CodeDeploy::BlueGreen hook.
      - At least one of the ECS resources that will trigger a blue/green deployment if replaced during a stack update. Currently, those resources are AWS::ECS::TaskDefinition and AWS::ECS::TaskSet.
    - Recommend you have CloudFormation generate a [change set](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-updating-stacks-changesets.html) for the green deployment, before initiating the stack update. This enables you to review the actual changes that will be made to the stack.
    - [Template example](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/blue-green.html#blue-green-template-example) that sets up an ECS blue/green deployment through CodeDeploy. Creating a stack with the template would provision the initial configuration of the deployment.

---

[Service auto scaling and deployments](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-auto-scaling.html)

Application Auto Scaling disables scale-in processes while Amazon ECS deployments are in progress. However, scale-out processes continue to occur, unless suspended, during a deployment. If you want to suspend scale-out processes while deployments are in progress, take the following steps.

Call the [describe-scalable-targets](https://docs.aws.amazon.com/cli/latest/reference/application-autoscaling/describe-scalable-targets.html) command, specifying the resource ID of the ECS service associated with the scalable target in Application Auto Scaling (Example: service/default/sample-webapp). Record the output. You will need it when you call the next command.

Call the [register-scalable-target](https://docs.aws.amazon.com/cli/latest/reference/application-autoscaling/register-scalable-target.html) command, specifying the resource ID, namespace, and scalable dimension. Specify true for both DynamicScalingInSuspended and DynamicScalingOutSuspended.

After deployment is complete, you can call the [register-scalable-target](https://docs.aws.amazon.com/cli/latest/reference/application-autoscaling/register-scalable-target.html) command to resume scaling.

For more information, see [Suspending and resuming scaling for Application Auto Scaling](https://docs.aws.amazon.com/autoscaling/application/userguide/application-auto-scaling-suspend-resume-scaling.html).
 - This topic explains how to suspend and then resume one or more of the scaling activities for the scalable targets in your application. The suspend-resume feature is used to temporarily pause scaling activities triggered by your scaling policies and scheduled actions. This can be useful, for example, when you don't want automatic scaling to potentially interfere while you are making a change or investigating a configuration issue. Your scaling policies and scheduled actions can be retained, and when you are ready, scaling activities can be resumed.
