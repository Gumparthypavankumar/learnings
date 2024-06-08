const express = require("express");
const app = express();
const PORT = process.env.PORT || 5000;

function errorHandler(err, req, res, next) {
    console.error({err});
    if(err instanceof AppError) {
        const status = err.status || 500;
        return res.status(status).json({message: err.message});
    }
    return res.status(500).json({message: err.message});
}

app.use(errorHandler);

app.get("/", (req, res, next) => {
    next(new AppError(503, "Custom message"));
    // return res.status(200).json({ message: "Success" });
});

class AppError extends Error {
    constructor(status, message) {
        super(message);
        if(isNaN(status)) {
            this.status = status;
        }
    }
}

app.listen(PORT, () => console.log(`App started on port: ${PORT}`));