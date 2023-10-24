# Load balancing

Imagine you have deployed an application - it is currently running on one EC2 instance. As per [Murphy's Law](https://en.wikipedia.org/wiki/Murphy%27s_law) we know that something ~~might~~ will go wrong at some point. Running an application where there is only one of them is great for costs but maybe not say great for reliability because you have a [SPOF](https://en.wikipedia.org/wiki/Single_point_of_failure)

One tactic a cloud engineer might employ to combat this type of risk is [Load Balancing](https://aws.amazon.com/what-is/load-balancing/).

## Scenario

Your task is to deploy a new Node API to two separate EC2 instances and load balance traffic between them.

You will make use of AWS Load Balancing along with your new found Terraform skills to create the required infrastructure.

You can view the code for API within the [app](./app/) directory where you will find:

* [index.js](./app/src/index.js) - This file contains the Javascript for the API. 

* [package.json](./app/package.json) - The file contains the dependencies for the application and the scripts for starting the API.

🗒️ **NOTE:** As part of this exercise you are safe to assume that the code has been tested and fully works so you do not need to edit any of the code within the app.

## Instructions

## 1. Applying the current infrastructure

Explore the existing terraform files within this repository to familiarise yourself with the structure.

You will see that there is already existing code to create a brand new VPC, associated subnets, routing and some security groups for the application.

Apply this infrastructure to your AWS account, once it has successfully applied you should see Terraform report the following success message

```
Apply complete! Resources: 21 added, 0 changed, 0 destroyed.
```

Have a look over the Terraform code before moving on. 

## 2. Application servers

Make sure to commit and push your code after each step in these instructions.

In this step you will create two application servers in the form of EC2 instances.

[aws_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)

You will provision two EC2 instances that you can later connect to and install the API on to.

Put your terraform code within the [app_servers](./modules/app_servers/) directory. Your code should:

* Provision two EC2 instances
* They should be **t2.micro** in size
* Use the previously created security group
* Place that instance within the VPC that you created with Terraform
* Be associated with the **key pair** you created earlier in programme
* Have the name `app_server_001` and `app_server_002` respectively
* Use the **Ubuntu Server 22.04 AMI ID** (ami-0505148b3591e4c07)
* The instance should be given a public IP address

**🗒️ NOTE:** If you have lost the key pair and need to make a new one then you can use the [AWS console to make a new key pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html) and reference that within your terraform code.

Once you are happy with the code you have written for your instances, go ahead and `apply` this using Terraform. You should see Terraform inform you that it has made new resources.

Log in to the AWS console to make sure you can see your two EC2 instances and check that you can SSH into them before moving on.

## 3. Deploying the application

Once your instances are ready, SSH into one of them in order to set it up and deploy the API on to it.

**🗒️ NOTE:** You should repeat these steps for both EC2 instances

Once you are logged in you should:

- Clone down this repository to your instance to get the code on the machine (You've done similar to this in previous exercises)
- Install Node & NPM
- Install the application dependencies with `npm install`
- Install pm2
- Start the server with pm2
 
At this stage its important to verify that you have the application running successfully before moving on.

Open up the AWS console in the browser and navigate to the EC2 section.

Click on your EC2 instance and you should see the **Instance summary**

Within the instance summary, you should see a section called **Public IPv4 DNS** and it will have a value similar (but not exactly) to the following:

```
ec2-18-170-107-81.eu-west-2.compute.amazonaws.com
```

Copy that value and then on another terminal, test the API using cURL

```
curl -X GET ec2-18-170-107-81.eu-west-2.compute.amazonaws.com:3000/
```

You should see something like the following

```
curl -X GET ec2-18-170-107-81.eu-west-2.compute.amazonaws.com:3000/

{"message":"Hello cloud engineering crew"}%
```

You can even test it in the browser if you want. Open up a browser and go to (replacing the address with whatever is the correct value)

```
http://ec2-18-170-107-81.eu-west-2.compute.amazonaws.com:3000/
```

🎉 🥳 Ok...so far so good....we can test the API and we have got it working!!

## 4. Target group

Now you have two servers running the API you can start work on load balancing between them.

In order to load balance you need to identify the two servers in a form of group. AWS does this through a service service called [Target groups](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html).

Write terraform code that will create an AWS target group

- [aws_lb_target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group)
- [aws_lb_target_group_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment)

The settings for your target group should be:

* Protocol should be **HTTP**
* Port should be **3000**
* Protocol version should be **HTTP1**
* Health check should be set up with a path of **/health-check** and a protocol of **HTTP**

Once you have created the target group your next step is to register those instances with your target group using the **aws_lb_target_group_attachment**. 

Use the instances you created within the [app_servers](./modules/app_servers) module and attach them to the target group.

Once you are happy with the code you have written for your target group, go ahead and `apply` this using Terraform. You should see Terraform inform you that it has made new resources.

## 5. Load balancer setup

Amazing work getting this far!!! Seriously well done! 🎉

Next and final section is to create the load balancer and load balance between your instances (as grouped by the target group). You will use Terraform to create an **Application Load Balancer**

* [aws_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb)
* [aws_lb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener)

Your load balancer should have the following properties:

* Internet-facing not internal
* Of type **application** for the **load_balancer_type**
* Reside in the public subnets created within the [networking](./modules/networking/) module
* Use the security group created within the [security](./modules/security/) module

Once your load balancer is there you can then configure the listener settings for the load balancer. This essentially tells your load balancer where to send the traffic for the application to

The listener should be setup with the following properties:

* Use HTTP
* Use port 80
* Set up using **Forward action** as the **default action** and the target should be the previously created target group
* You won't need SSL policy or certificates because it doesn't use HTTPS

Once you are happy with the code you have written for your load balancer setup, go ahead and `apply` this using Terraform. You should see Terraform inform you that it has made new resources.

## 6. Time for testing

Once your load balancer is created, on your browser, open up the AWS console and through to the Load Balancers section.

Select your load balancer from the list and you should see a section called **DNS Name**

Copy the URL that it shows and open that up in your browser or you can test with curl such as (your URL will be different to ones shown):

```
curl -X GET api-load-balancer-1270613838.eu-west-2.elb.amazonaws.com
```

You can try another end point such as the `/learners`

```
curl -X GET api-load-balancer-1270613838.eu-west-2.elb.amazonaws.com/learners
```

Maybe try to add a few learners

```
curl -X POST api-load-balancer-1270613838.eu-west-2.elb.amazonaws.com/learners \
   -H 'Content-Type: application/json' \
   -d '{"firstName":"John Doe","class":"Cloud Engineering"}'

curl -X POST api-load-balancer-1270613838.eu-west-2.elb.amazonaws.com/learners \
   -H 'Content-Type: application/json' \
   -d '{"firstName":"Susie Smith","class":"Cloud Engineering"}'

curl -X POST api-load-balancer-1270613838.eu-west-2.elb.amazonaws.com/learners \
   -H 'Content-Type: application/json' \
   -d '{"firstName":"Anika Agarwal","class":"Cloud Engineering"}'
```

Now try getting the learners again....

```
curl -X GET api-load-balancer-1270613838.eu-west-2.elb.amazonaws.com/learners
```

🤔 You might find that you don't get all your learners when you make a request to get the learners. Don't worry that is a flaw in how the code is designed. Can you work out why that is happening? 🤔

🎉 🥳 Time to celebrate!! You've successfully configured a load balancer on AWS to distribute traffic between instances!!!

Cloud engineering jobs here we come!!

Now give yourself a pat on the back, have a relax and when ready work through the submission process below before you tear things down.

## 7. Putting it into practice

Using what you have learnt, we'd like you to get multiple microservices deployed behind a load balancer.

The microservices are for a home energy management system ⚡️. You can send requests to turn lights on/off, requests for heating on/off and even check the status of home energy.

Create a yourself brand new git repository to store your terraform code and write the code to:

* Create a VPC for your new application services
* Any required security groups
* EC2 instances running different applications
* Different target groups for the different services
* An [AWS load balancer that uses path based routing](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html) to route to different target groups

Each of the various applications can be found on the link below:

* EMILY UPDATE GITHUB LINKS
* EMILY UPDATE GITHUB LINKS
* EMILY UPDATE GITHUB LINKS


## Tearing things down

You can use terraform to remove the infrastructure you have created by running:

`terraform destroy`