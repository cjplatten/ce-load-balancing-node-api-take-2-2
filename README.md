# Load balancing

In this exercise you will manually deploy a Node [Express API](https://expressjs.com/) to multiple EC2 servers

Once deployed (and verified to be working) you will then move on to load balancing between them using an [AWS Application Load Balancer (ALB)](https://aws.amazon.com/elasticloadbalancing/)

Let's get started 🥳

## Instructions

### 1. Explore the code files

The code for the API can be found within the [app](./app) directory. Firstly have a look over the code files

[index.js](./app/src/index.js) - This file contains the Javascript for the API. 

[package.json](./app/package.json) - The file contains the dependencies for the application and the scripts for starting the API.

### 2. Testing locally

Before you deploy this API up to the cloud, let us get used to testing this API locally

If you've haven't got node installed on your computer then you'll need to install node. One way of doing this is to use [Node Version Manager](https://github.com/nvm-sh/nvm)

Once node is installed you should be able to run the following command to check your node version.

```
node --version
```

For starting the application navigate into the app directory and run:

```
npm install
```

Followed by 

```
npm start
```

That will start the application. 

Then let's practice some more command line and test it with the curl command. Try the following:

```
curl -X GET localhost:3000/
```

You should see something like:

```
curl -X GET localhost:3000/

{"message":"Hello cloud engineering crew"}% 
```

Now lets try getting a list of learners, try:

```
curl -X GET localhost:3000/learners
```

and you should see

```
curl -X GET localhost:3000/learners

[]
```

Now instead of doing a `GET` request, let's do a `POST` request and save a learner. Try the following

```
curl -X POST localhost:3000/learners \
   -H 'Content-Type: application/json' \
   -d '{"firstName":"Jane Doe","class":"Cloud Engineering"}'
```

Once the POST request has completed, try getting the learners again and you should see something similar to this:

```
curl -X GET localhost:3000/learners   

[{"firstName":"Jane Doe","class":"Cloud Engineering"}]
```

🤩 Nice so now you know what the experience should be like when you deploy this application.

### 3. Setup security group

Next you are going to configure a [security group](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html)

AWS security groups act as firewall rules and either block (by default) or allow traffic into the server. By default they will block all inbound traffic and allow all outbound traffic.

Navigate to the **EC2** section of AWS and go into **Security Groups**

Once there you might see a number of generated security groups, click **Create security group**

Call the security group **learners-api-sg**

Give the security group a description of **Security group for learners API servers**

Place it within the **Default VPC**

Under **Inbound rules** add five rules

| Type       | Port range | Source        | Description                 |
| -----------|:----------:| -------------:|----------------------------:|
| Custom TCP | 3000       | Anywhere IPv4 | API server inbound IPv4     |
| Custom TCP | 3000       | Anywhere IPv6 | API server inbound IPv6     |
| HTTP       | 80         | Anywhere IPv4 | API server inbound IPv4     |
| HTTP       | 80         | Anywhere IPv6 | API server inbound IPv6     |
| SSH        | 22         | My IP         | SSH access from my computer |



### 4. Provision EC2 instance

🗒️ Note: Creating the EC2 instance within the default VPC will be fine for this exercise because we'll need internet access.

Give the instance a name such as `api-server-001`

Choose the Ubuntu AMI (we'll continue with instructions assuming you are running Ubuntu)

For instance type, the free tier will be absolutely fine for this exercise.

Choose **existing security group** and select your previously created security group

Choose an existing **key/pair** if you still have the key available or if not create a new key pair and called it a new name such as **learners-api-keypair**

### 5. SSH into the instance

Once the instance is ready, SSH into it in order for us to set it up and deploy the API on to it.

### 6. Install node

Once you are logged into the server install NodeJS

```
sudo apt update
```

Followed by

```
sudo apt install nodejs
```

Then you should be able to run the following command to check you have installed node successfully on the server

```
node --version
```

Next we need to install `npm`

If you see a message about restart packages simply hit `<return>`

```
sudo apt install npm
```

### 7. Clone your code

The next thing you need to do is get the code from GitHub on to the server you have created.

We could just clone the code from your repository on to the server. But....we have a problem - your GitHub repository is private so we'll need to use your username and password.

On the GitHub website, navigate to your fork of this repository that contains the code for application.

Click the **Code** button and choose the **HTTPS** tab.

Copy the URL that is shown

Then on the EC2 instance run the following command (replacing YOUR-USERNAME with the correct path to your repository):

```
git clone https://github.com/YOUR-USERNAME/ce-load-balancing-node-api.git
```

🗒️ Note: If you have multifactor authentication enabled on your Git account, get in touch with your coach in order to get help on authenticating with SSH.

### 8. Start up your application

Once the clone has completed navigate into the directory to install dependencies and start the application

```
cd ce-load-balancing-node-api/app
```

Install dependencies

```
npm install
```

Try starting the application

```
npm start
```

You should see the application start up

```
npm start

> app@1.0.0 start
> node src/index.js

Server Running on PORT 3000
```

### 9. Test hitting the application from your browser

Whilst the app is running on your terminal, open up the AWS console in the browser and navigate to the EC2 section.

Click on your EC2 instance and you should see the **Instance summary**

Within the instance summary, you should see a section called **Public IPv4 DNS** and it will have a value similar (but not exactly) to the following:

```
ec2-18-170-107-81.eu-west-2.compute.amazonaws.com
```

Copy that value and then on another tab, test the API using cURL

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

### 10. Running in the background

Back on the server now, hit `Ctrl+C` to stop the server

The server starts fine but if you were to exit the terminal it would stop because you aren't running the server "in the background"

To run the server in the background we will use a tool called [PM2](https://www.npmjs.com/package/pm2)

To install **pm2** run

```
sudo npm install pm2 -g
```

Then to start the app in the background run

```
pm2 start src/index.js
```

You can now exit your SSH session to that server by running the command:

```
exit
```

If you test your API from cURL or the browser you should find that it still works.

### 11. Setting up the second server

We're going to create a carbon copy of the first server so that we can load balance between two instances.

Follow steps 4 to 10 again to make a second instance. You can give your next instance a name such as **api-server-002**

### 12. Target group

Now you have two servers running the API you can start work on laod balancing between them.

In order to load balance we need to identify the two servers in a form of group. AWS does this through a service service called [Target groups](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html).

Under the EC2 section of the console you will see **Target groups**, navigate to that section and create a new Target Group

Make sure **Instances** is selected for the **Target type**

Give the target group a name that identifies it's purpose

For the **Protocol** and **Port** make sure `HTTP` is selected and the port is `3000`

The **Protocol version** can be left as **HTTP1**

For **Health checks**, make sure that the protocol is **HTTP** and the **Health check path** should be `/health-check`

Register your EC2 instances as targets for the Target group

### 13. Load balancer setup

Next and final section is to create the load balancer and load balance between our instances (as grouped by the target group)

Go in to **Load balancers** and create an **Application Load Balancer**

Give your load balancer a name

Make sure that `Internet-facing` is selected for the **Scheme** and that  `IPv4` is selected for the **IP address type**

Pick at least two subnets from the `Default VPC` under the **Mappings** section

For **Security groups** make sure to pick your previously created security group (this will ensure port 80 is open)

The **Listener** section should be configured to use HTTP, port 80 and the **Default action** should be to forward to the target group you created.

Go ahead and create your load balancer

### 14. Time for testing

Once your load balancer is created, select it from the list and you should see a section called **DNS Name**

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

🤔 You might find that you don't get all your learners when you make a request to get the learners. Don't worry that is a flaw in how the code is designed. There's a question for you to answer about it later 😉

🎉 🥳 Time to celebrate!! You've successfully configured a load balancer on AWS to distribute traffic between instances!!!

Cloud engineering jobs here we come!!

Now give yourself a pat on the back, have a relax and when ready work through the submission process below before you tear things down.

## Extension

Try the above exercises using the AWS CLI to provision the various required aspects


## Submission process

1. Fork and clone this repository

2. Follow through the instructions above

3. Create a SOLUTION.md and populate it with answers to the following questions/actions:
    * What endpoints and what [request methods](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods) does the API currently support?
    * Why do you think we use the port **3000** within the security group setup?
    * When setting up the ALB you had to specify a health check endpoint - why is that?
    * What is a load balancer and why might you use one?
    * Explain, in your own words, what security groups are?
    * Currently the application listens on port 3000, this isn't a standard HTTP port - what two ports would be better to use?
    * When the API is deployed behind a load balancer, if you add multiple learners and then re-try **GET**ting the learners, sometimes it shows the learners you have added other times it doesn't. Why is that?
    * Which bits of the setup do you think you could automate and why?
    * Add an image to the repository that shows your browser hitting the API and listing learners. Link that image within your SOLUTION.md markdown document
    * If you completed the extension exercise and used the AWS CLI to undertake the AWS actions, include a section called **AWS Commands** in your SOLUTION.md that outlines the commands you used
    

4. Share your GitHub link

5. Follow through the **Tearing things down** instructions


## Tearing things down

In order to remove the infrastructure we have created, follow these steps in order

* Navigate to Load Balancers and delete the load balancer

* Navigate to Target groups and delete the target group

* Navigate to the EC2 section and terminate your two EC2 instances

## Further reading