import express from "express";

const app = express();
const port = process.env.PORT || 3000;

app.get("/", (req, res) => {
  res.json({
    message: "Hello from DevOps project",
    env: process.env.NODE_ENV || "dev",
  });
});

app.get("/health", (req, res) => {
  res.send("OK");
});

app.listen(port, () => {
  console.log("Server running on port " + port);
});
