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

### 3. Provision EC2 instance

Using past experience, log on to AWS and create an EC2 instance

For instance type, the free tier will be absolutely fine for this exercise.

As an extra challenge, you could try creating the AWS instance using the AWS CLI

Choose the Ubuntu AMI (we'll continue with instructions assuming you are running Ubuntu)






## Submission process

1. Fork and clone this repository

2. Follow through the instructions above

3. Create a SOLUTION.md and populate it with answers to the following questions:
    * What endpoints and what [request methods](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods) does the API currently support?
    * When setting up the ALB you had to specify a health check endpoint - why is that?
    * Currently the application listens on port 3000, this isn't a standard HTTP port - what two ports would be better to use?
    * When the API is deployed behind a load balancer, if you add multiple learners and then re-try **GET**ting the learners, sometimes it shows the learners you have added other times it doesn't. Why is that?

4. Share your GitHub link

5. Follow through the **Tearing things down** instructions



## Tearing things down

## Further reading