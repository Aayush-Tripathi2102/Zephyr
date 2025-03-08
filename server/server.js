const { ethers } = require("ethers");
const express = require("express");
const http = require("http");
const { Server } = require("socket.io");
const { dotenv } = require("dotenv");

const lendingPoolABI = [
    "event DepositCollateral(address indexed user, address token, uint256 amount)",
    "event DepositStablecoin(address indexed user, uint256 amount)",
    "event WithdrawStablecoin(address indexed user, uint256 amount)",
    "event Borrow(address indexed user, uint256 amount)",
    "event Repay(address indexed user, uint256 amount)",
    "event Liquidation(address indexed liquidator, address indexed borrower, uint256 amountLiquidated)",
    "event LoanRepaid(address indexed borrower, uint256 totalRepaid, uint256 interestPaid)",
    "event InterestRate(uint256 interest)",
    "event InterestAndRate(uint interest, uint Rate)",
    "function depositCollateral(address token, uint256 amount) external",
    "function depositStablecoin(uint256 amount) external",
    "function withdrawStablecoin(uint256 amount) external",
    "function borrow(uint256 amount) external",
    "function repay(uint256 amount) external",
    "function liquidate(address borrower) external",
    "function getInterest() external",
    "function calculateBorrowRate() public view returns (uint256)",
    "function totalStablecoinDeposits() view returns (uint256)",
    "function getInvestedCapital() external view returns (uint256)"
];

class BlockchainServer {
    constructor() {
        this.app = express();
        this.server = http.createServer(this.app);
        this.io = new Server(this.server);

        this.provider = new ethers.WebSocketProvider(
            `${process.env.RPC_URL}`
        );

        this.contractAddresses = {
            lendingPool: `${process.env.CONTRACT_ADDRESS}`,
        };

        this.contracts = {};
        this.initializeContracts();
        this.setupSocketEvents();
        this.setupBlockchainListeners();
    }

    initializeContracts() {
        this.signer = new ethers.Wallet(
            `${process.env.PRIVATE_KEY}`,
            this.provider
        );
        this.contracts.lendingPool = new ethers.Contract(
            this.contractAddresses.lendingPool,
            lendingPoolABI,
            this.signer // Use signer for write transactions
        );
    }

    setupSocketEvents() {
        this.io.on("connection", (socket) => {
            console.log("New client connected");

            socket.on("getUserLoans", async(address) => {
                try {
                    const loans = await this.getUserLoans(address);
                    socket.emit("userLoans", loans);
                } catch (error) {
                    socket.emit("error", error.message);
                }
            });

            socket.on("depositCollateral", async({ token, amount }) => {
                try {
                    const tx = await this.depositCollateral(token, amount);
                    socket.emit("depositCollateralSuccess", tx);
                } catch (error) {
                    socket.emit("error", error.message);
                }
            });

            socket.on("InterestAndRate", async() => {
                try {
                    const tx = await this.getInterest();
                    socket.emit("depositCollateralSuccess", tx);
                } catch (error) {
                    socket.emit("error", error.message);
                }
            });

            socket.on("depositStablecoin", async({ user, amount }) => {
                try {
                    const tx = await this.depositStablecoin(user, amount);
                    socket.emit("depositStablecoinSuccess", tx);
                } catch (error) {
                    socket.emit("error", error.message);
                }
            });

            socket.on("getInvestedCapital", async() => {
                try {
                    const tx = await this.getInvestedCapital();
                    socket.emit("sucess", tx);
                } catch (error) {
                    socket.emit("error", error.message);
                }
            })

            socket.on("borrow", async({ amount }) => {
                try {
                    const tx = await this.borrow(amount);
                    socket.emit("borrowSuccess", tx);
                } catch (error) {
                    socket.emit("error", error.message);
                }
            });

            socket.on("withdrawStablecoin", async({ user, amount }) => {
                try {
                    const tx = await this.withdrawStablecoin(user, amount);
                    socket.emit("withdrawSuccess", tx);
                } catch (error) {
                    socket.emit("error", error.message);
                }
            });

            socket.on("repay", async({ user, amount }) => {
                try {
                    const tx = await this.repay(user, amount);
                    socket.emit("repaySuccess", tx);
                } catch (error) {
                    socket.emit("error", error.message);
                }
            });

            socket.on("liquidate", async({ borrower }) => {
                try {
                    const tx = await this.liquidate(borrower);
                    socket.emit("liquidateSuccess", tx);
                } catch (error) {
                    socket.emit("error", error.message);
                }
            });

            socket.on("totalStablecoinDeposits", async() => {
                try {
                    const value = await this.totalStablecoinDeposits();
                    socket.emit("receivedSuccess", value);
                } catch (error) {
                    socket.emit("error", error.message);
                }
            })

            socket.on("disconnect", () => {
                console.log("Client disconnected");
            });
        });
    }

    setupBlockchainListeners() {
        this.contracts.lendingPool.on(
            "DepositStablecoin",
            (lender, amount, event) => {
                console.log({
                    status: "works",
                    lender,
                    amount,
                    block: event.blockNumber,
                });
                this.io.emit("newDeposit", {
                    lender,
                    amount,
                    block: event.blockNumber,
                });
            }
        );
    }

    async depositCollateral(tokenAddress, amount) {
        const contractWithSigner = this.contracts.lendingPool.connect(this.signer);
        const tx = await contractWithSigner.depositCollateral(tokenAddress, amount);
        await tx.wait();
        return tx;
    }

    async depositStablecoin(userAddress, amount) {
        const contractWithSigner = this.contracts.lendingPool.connect(this.signer);

        try {
            // Ensure the user has approved the contract to spend the stablecoin
            const tx = await contractWithSigner.depositStablecoin(amount);
            await tx.wait();
            console.log("Deposit successful:", tx);
            return tx;
        } catch (error) {
            console.error("Error depositing stablecoin:", error);
            throw new Error("Deposit failed: " + error.message);
        }
    }

    async getUserLoans(address) {
        try {
            const loans = await this.contracts.lendingPool.getUserLoans(address);
            return loans;
        } catch (error) {
            console.error("Error fetching user loans:", error);
            throw error;
        }
    }

    async borrow(amount) {
        const contractWithSigner = this.contracts.lendingPool.connect(this.signer);
        const tx = await contractWithSigner.borrow(amount);
        await tx.wait();
        return tx;
    }

    async repay(userAddress, amount) {
        const contractWithSigner = this.contracts.lendingPool.connect(this.signer);
        const tx = await contractWithSigner.repay(amount);
        await tx.wait();
        return tx;
    }

    async withdrawStablecoin(userAddress, amount) {
        const contractWithSigner = this.contracts.lendingPool.connect(this.signer);
        try {
            // Ensure the user has approved the contract to spend the stablecoin
            const tx = await contractWithSigner.withdrawStablecoin(amount);
            await tx.wait();
            console.log("withdraw successful:", tx);
            return tx;
        } catch (error) {
            console.error("Error withdrawing stablecoin:", error);
            throw new Error("withdraw failed: " + error.message);
        }
    }

    async liquidate(borrower) {
        const contractWithSigner = this.contracts.lendingPool.connect(this.signer);
        const tx = await contractWithSigner.liquidate(borrower);
        await tx.wait();
        return tx;
    }

    async totalStablecoinDeposits() {
        const contractWithSigner = this.contracts.lendingPool.connect(this.signer);
        const tx = await contractWithSigner.totalStablecoinDeposits();
        return tx;
    }

    async getInvestedCapital() {
        const contractWithSigner = this.contracts.lendingPool.connect(this.signer);
        const tx = await contractWithSigner.getInvestedCapital();
        return tx;
    }

    async canBorrow(userAddress, amount) {
        return await this.contracts.lendingPool.canBorrow(userAddress, amount);
    }

    async calculateBorrowRate() {
        return await this.contracts.lendingPool.calculateBorrowRate();
    }

    async checkCollateralRatio(userAddress) {
        return await this.contracts.lendingPool.checkCollateralRatio(userAddress);
    }

    async getTotalCollateralValue(userAddress) {
        return await this.contracts.lendingPool.getTotalCollateralValue(
            userAddress
        );
    }

    async getInterest() {
        return await this.contracts.lendingPool.getInterest();
    }



    start(port = 3000) {
        this.server.listen(port, () => {
            console.log(`Blockchain server running on port ${port}`);
        });
    }
}

const server = new BlockchainServer();
server.start();