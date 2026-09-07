import express from "express";
import http from "http";
import { Server } from "socket.io";
import mongoose from "mongoose";
import dotenv from "dotenv";
import cors from "cors";
import userRoutes from "./routes/userRoutes.js";
import User from "./models/User.js";
import Message from "./models/Message.js";
import reportRoutes from "./routes/reportRoutes.js";


dotenv.config();

const app = express();

const server = http.createServer(app);

// Middleware
app.use(express.json());
app.use(cors());

mongoose
    .connect(process.env.MONGO_URI)
    .then(() => console.log("Connected to MongoDB"))
    .catch((err) => console.error("MongoDB connection error:", err));

const io = new Server(server, {
    cors: {
        origin: "*",
    }
})

let activeUsers = new Map();

io.on("connection", (socket) => {
    console.log("User connected" + socket.id),
        socket.on("addUser", (userId) => {
            activeUsers.set(userId, socket.id);
        })


    socket.on("sendMessage", async ({ senderId, receiverID, text }) => {
        const message = new Message({ sender: senderId, receiver: receiverID, text });
        await message.save();

        const receiverSocket = activeUsers.get(receiverID);
        if (receiverSocket) {
            io.to(receiverSocket).emit("getMessage", {
                senderId,
                text,
                createdAt: message.createdAt
            });
        }
    });
});
app.get("/messages/:user1/:user2", async (req, res) => {
    const { user1, user2 } = req.params;
    const messages = await Message.find({
        $or: [
            { sender: user1, receiver: user2 },
            { sender: user2, receiver: user1 }
        ]
    });
    res.json(messages);
});

app.post("/messages", async (req, res) => {
    const { sender, receiver, text } = req.body;
    const message = new Message({ sender, receiver, text });
    await message.save();
    res.json(message);
});

app.delete("/messages/:id", async (req, res) => {
    console.log(req.params);
    const deletedMessage = await (Message.findById(req.params.id)).catch(err => { console.log(err) });
    console.log("line 71: " + deletedMessage)
    await (Message.findByIdAndDelete(req.params.id)).catch(err => { console.log(err) });
    res.end();
});

app.put("/messages/:id", async (req, res) => {
    console.log(req.params);
    const { sender, receiver, text } = req.body;
    const newMessage = await (Message.findByIdAndUpdate(req.params.id, { text: `${text}` })).catch(err => { console.log(err) });
    await newMessage.save();
    res.json(newMessage);
})


// Routes
app.get("/", (req, res) => res.send("Welcome to Miira Matchmaking Backend"));
app.use("/api/users", userRoutes);
app.use("/api/reports", reportRoutes);

const PORT = process.env.PORT || 5050;
app.listen(PORT, "0.0.0.0", () =>
  console.log(`Server running on port ${PORT}`)
);
