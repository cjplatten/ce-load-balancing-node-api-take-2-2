const express = require("express");

const PORT = 3000;

const app = express();

// enable JSON parsing middleware
app.use(express.json());


const learners = [];

app.get("/", (req, res) => {
	res.json({ message: "Hello cloud engineering crew"  });
})

app.get("/learners", (req, res) => {
	res.json(learners);
})

app.post("/learners", (req, res) => {
    const learner = req.body;
    learners.push(learner);
	res.json({message: "Learner saved"});
})

app.get("/health-check", (req, res) => {
	res.json({ message: "Server up and running"  });
})

app.listen(PORT, () => {
	console.log("Server Running on PORT", PORT);
})