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

Before you deploy this API up to the cloud, let us get used to testing this locally

## Submission process

1. Fork and clone this repository

2. Follow through the instructions above

3. Create a SOLUTION.md and populate it with answers to the following questions:
    * What endpoints and what [request methods](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods) does the API currently support?
    * When setting up the ALB you had to specify a health check endpoint - why is that?
    * Currently the application listens on port 3000, this isn't a standard HTTP port - what two ports would be better to use?
    * If you add multiple learners and then re-try **GET**ting the learners, sometimes it shows the learners you have added other times it doesn't. Why is that?

4. Share your GitHub link

5. Follow through the **Tearing things down** instructions



## Tearing things down

## Further reading