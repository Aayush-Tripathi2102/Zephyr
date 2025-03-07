"use client";
import { useRef, useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { getLoggedInUser, logout } from "@/lib/appwrite";
import BlurText from "@/components/BlurText/BlurText";
import { io, Socket } from "socket.io-client";
import Navbar from "@/components/Navbar";
import { motion } from "framer-motion";
import {
  ArrowUpRight,
  ChevronDown,
  Clock,
  DollarSign,
  LineChart,
  Plus,
  Wallet,
} from "lucide-react";

import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";

export default function Dashboard() {
  const [showNewInvestmentDialog, setShowNewInvestmentDialog] = useState(false);
  const [showWithdrawDialog, setShowWithdrawDialog] = useState(false);
  const [amount, setAmount] = useState("");
  const [withdraw, setWithdraw] = useState("");
  const socketRef = useRef<Socket | null>(null);
  const user = '466b159ba624b6f7dedf851424e0f3366727901632206f3c2b0479863da3bd3f'

  // Mock data - would be fetched from blockchain/API in a real implementation
  const stats = {
    totalInvested: "12,450.00",
    phyrTokens: "1,245.00",
    totalInterest: "1,230.50",
    pendingInterest: "45.32",
    apy: "8.2",
  };

  const investments = [
    {
      id: 1,
      pool: "Stable Yield",
      amount: "5,000.00",
      tokens: "500.00",
      interest: "410.25",
      apy: "8.2",
      date: "2023-12-15",
    },
    {
      id: 2,
      pool: "Growth Fund",
      amount: "7,450.00",
      tokens: "745.00",
      interest: "820.25",
      apy: "11.0",
      date: "2024-01-22",
    },
  ];
  const [username, setUsername] = useState("");
  const [greeting, setGreeting] = useState("");
  const router = useRouter();

  useEffect(() => {
    const fetchUser = async () => {
      const user = await getLoggedInUser();
      if (user) {
        setUsername(user.name);
      } else {
        router.push("/login");
      }
    };
    fetchUser();
  }, [router]);

  useEffect(() => {
    const socket = io("https://zephyr-server-remx.onrender.com/", {
      transports: ["websocket"],
      reconnection: true,
      reconnectionAttempts: 5,
      timeout: 10000,
    });

    socket.on("connect", () => {
      console.log("Connected to Socket.IO server");
    });

    socket.on("connect_error", (error) => {
      console.error("Socket connection error:", error);
    });

    socket.on("disconnect", (reason) => {
      console.log("Disconnected from Socket.IO server:", reason);
    });

    socketRef.current = socket;

    return () => {
      socket.disconnect(); // Cleanup on unmount
    };
  }, []);

  useEffect(() => {
    const hour = new Date().getHours();
    if (hour >= 0 && hour < 4) {
      setGreeting("So Late??");
    } else if (hour < 12) {
      setGreeting("Good Morning");
    } else if (hour < 18) {
      setGreeting("Good Afternoon");
    } else {
      setGreeting("Good Evening");
    }
  }, []);

  const handleLogout = async () => {
    await logout();
    router.push("/login");
  };

  const handleClick = () => {
    if (socketRef.current) {
      socketRef.current.emit("depositStablecoin", { user, amount });
      
    }
  }

  const handleWithdraw = () => {
    if (socketRef.current) {
      socketRef.current.emit("withdrawStablecoin", { user, withdraw });
    }
  }
  

  return (
    <>
      <Navbar />
      <div className="flex min-h-screen flex-col bg-black text-white">
        <main className="flex-1 p-6 md:p-8">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
            className="flex flex-col gap-8"
          >
            <div className="flex flex-col gap-2 md:flex-row md:items-center md:justify-between">
              <div>
                <div className="flex flex-col justify-center text-white">
                  <BlurText
                    text={`Hey ${username}, ${greeting}!`}
                    delay={150}
                    animateBy="words"
                    direction="top"
                    className="mb-4 text-4xl font-bold"
                  />
                </div>
                <p className="text-sm text-zinc-400">
                  Track your investments and earnings in the Zephyr protocol
                </p>
              </div>
              <div className="flex gap-3">
                <Dialog
                  open={showNewInvestmentDialog}
                  onOpenChange={setShowNewInvestmentDialog}
                >
                  <DialogTrigger asChild>
                    <Button className="bg-gradient-to-r from-purple-700 to-purple-600 hover:from-purple-600 hover:to-purple-500">
                      <Plus className="mr-2 h-4 w-4" /> New Investment
                    </Button>
                  </DialogTrigger>
                  <DialogContent className="border-purple-800 bg-zinc-900 text-white sm:max-w-[425px]">
                    <DialogHeader>
                      <DialogTitle>Create New Investment</DialogTitle>
                      <DialogDescription className="text-zinc-400">
                        Enter the amount you want to invest in the Zephyr
                        protocol.
                      </DialogDescription>
                    </DialogHeader>
                    <div className="grid gap-4 py-4">
                      <div className="grid gap-2">
                        <Label htmlFor="pool">Select Pool</Label>
                        <select
                          id="pool"
                          className="flex h-10 w-full rounded-md border border-zinc-800 bg-zinc-950 px-3 py-2 text-sm text-white ring-offset-purple-600 focus:outline-none focus:ring-2 focus:ring-purple-600"
                        >
                          <option value="stable">
                            Stable Yield (8.2% APY)
                          </option>
                          <option value="growth">
                            Growth Fund (11.0% APY)
                          </option>
                          <option value="premium">
                            Premium Pool (14.5% APY)
                          </option>
                        </select>
                      </div>
                      <div className="grid gap-2">
                        <Label htmlFor="amount">Amount</Label>
                        <Input
                          id="amount"
                          placeholder="0.00"
                          className="border-zinc-800 bg-zinc-950 text-white"
                          value={amount}
                          onChange={(e) => setAmount(e.target.value)}
                        />
                        <p className="text-xs text-zinc-500">
                          You will receive PHYR tokens based on current exchange
                          rate
                        </p>
                      </div>
                    </div>
                    <DialogFooter>
                      <Button
                        variant="outline"
                        className="border-zinc-800 text-white hover:bg-zinc-800 bg-zinc-700"
                        onClick={() => setShowNewInvestmentDialog(false)}
                      >
                        Cancel
                      </Button>
                      <Button onClick={handleClick} className="bg-gradient-to-r from-purple-700 to-purple-600 hover:from-purple-600 hover:to-purple-500">
                        Invest Now
                      </Button>
                    </DialogFooter>
                  </DialogContent>
                </Dialog>

                <Dialog
                  open={showWithdrawDialog}
                  onOpenChange={setShowWithdrawDialog}
                >
                  <DialogTrigger asChild>
                    <Button
                      variant="outline"
                      className="border-purple-800 bg-transparent hover:bg-purple-900/20"
                    >
                      <Wallet className="mr-2 h-4 w-4" /> Withdraw Interest
                    </Button>
                  </DialogTrigger>
                  <DialogContent className="border-purple-800 bg-zinc-900 text-white sm:max-w-[425px]">
                    <DialogHeader>
                      <DialogTitle>Withdraw Interest</DialogTitle>
                      <DialogDescription className="text-zinc-400">
                        Withdraw your earned interest from Zephyr protocol.
                      </DialogDescription>
                    </DialogHeader>
                    <div className="grid gap-4 py-4">
                      <div className="rounded-lg bg-zinc-800/50 p-4">
                        <div className="flex justify-between">
                          <span className="text-zinc-400">
                            Available Interest
                          </span>
                          <span className="font-medium">
                            ${stats.pendingInterest}
                          </span>
                        </div>
                      </div>
                      <div className="grid gap-2">
                        <Label htmlFor="withdraw-amount">
                          Amount to Withdraw
                        </Label>
                        <Input
                          id="withdraw-amount"
                          placeholder="0.00"
                          defaultValue={stats.pendingInterest}
                          className="border-zinc-800 bg-zinc-950 text-white"
                          value={withdraw}
                          onChange={(e) => setWithdraw(e.target.value)}
                        />
                      </div>
                    </div>
                    <DialogFooter>
                      <Button
                        variant="outline"
                        className="border-zinc-800 text-white hover:bg-zinc-800"
                        onClick={() => setShowWithdrawDialog(false)}
                      >
                        Cancel
                      </Button>
                      <Button onClick={handleWithdraw} className="bg-gradient-to-r from-purple-700 to-purple-600 hover:from-purple-600 hover:to-purple-500">
                        Withdraw Now
                      </Button>
                    </DialogFooter>
                  </DialogContent>
                </Dialog>
              </div>
            </div>

            {/* Stats Overview */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5, delay: 0.1 }}
              className="grid gap-4 md:grid-cols-2 lg:grid-cols-4"
            >
              <Card className="border-purple-800/30 bg-gradient-to-b from-purple-900/20 to-black">
                <CardHeader className="pb-2">
                  
                  <CardDescription className="text-zinc-400">
                    Total Invested
                  </CardDescription>
                  <CardTitle className="text-2xl font-bold">
                    ${stats.totalInvested}
                  </CardTitle>
                </CardHeader>
                <CardFooter className="pt-2">
                  <p className="text-xs text-zinc-500">Across all pools</p>
                </CardFooter>
              </Card>

              <Card className="border-purple-800/30 bg-gradient-to-b from-purple-900/20 to-black">
                <CardHeader className="pb-2">
                  <CardDescription className="text-zinc-400">
                    PHYR Tokens
                  </CardDescription>
                  <CardTitle className="text-2xl font-bold">
                    {stats.phyrTokens}
                  </CardTitle>
                </CardHeader>
                <CardFooter className="pt-2">
                  <p className="text-xs text-zinc-500">Current token balance</p>
                </CardFooter>
              </Card>

              <Card className="border-purple-800/30 bg-gradient-to-b from-purple-900/20 to-black">
                <CardHeader className="pb-2">
                  <CardDescription className="text-zinc-400">
                    Total Interest Earned
                  </CardDescription>
                  <CardTitle className="text-2xl font-bold">
                    ${stats.totalInterest}
                  </CardTitle>
                </CardHeader>
                <CardFooter className="pt-2">
                  <p className="text-xs text-zinc-500">
                    Since you started investing
                  </p>
                </CardFooter>
              </Card>

              <Card className="border-purple-800/30 bg-gradient-to-b from-purple-900/20 to-black">
                <CardHeader className="pb-2">
                  <CardDescription className="text-zinc-400">
                    Average APY
                  </CardDescription>
                  <CardTitle className="text-2xl font-bold">
                    {stats.apy}%
                  </CardTitle>
                </CardHeader>
                <CardFooter className="pt-2">
                  <p className="text-xs text-zinc-500">
                    Across all investments
                  </p>
                </CardFooter>
              </Card>
            </motion.div>

            {/* Main Content */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5, delay: 0.2 }}
            >
              <Tabs defaultValue="investments" className="w-full">
                <TabsList className="grid w-full grid-cols-2 bg-zinc-900">
                  <TabsTrigger
                    value="investments"
                    className="data-[state=active]:bg-purple-900/30 data-[state=active]:text-white"
                  >
                    Your Investments
                  </TabsTrigger>
                  <TabsTrigger
                    value="analytics"
                    className="data-[state=active]:bg-purple-900/30 data-[state=active]:text-white"
                  >
                    Analytics
                  </TabsTrigger>
                </TabsList>

                <TabsContent value="investments" className="mt-6">
                  <div className="rounded-lg border border-zinc-800 bg-gradient-to-b from-zinc-900/50 to-black">
                    <div className="p-6">
                      <h3 className="text-lg font-medium">
                        Active Investments
                      </h3>
                      <p className="text-sm text-zinc-400">
                        Your current investments in the Zephyr protocol
                      </p>
                    </div>

                    <div className="px-6">
                      {investments.map((investment, index) => (
                        <motion.div
                          key={investment.id}
                          initial={{ opacity: 0, y: 10 }}
                          animate={{ opacity: 1, y: 0 }}
                          transition={{ duration: 0.3, delay: 0.1 * index }}
                          className="border-t border-zinc-800 py-6"
                        >
                          <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
                            <div>
                              <h4 className="flex items-center text-lg font-medium">
                                {investment.pool}
                                <span className="ml-2 rounded-full bg-purple-900/30 px-2 py-0.5 text-xs text-purple-300">
                                  {investment.apy}% APY
                                </span>
                              </h4>
                              <p className="text-sm text-zinc-400">
                                Invested on{" "}
                                {new Date(investment.date).toLocaleDateString()}
                              </p>
                            </div>

                            <div className="grid grid-cols-2 gap-4 md:flex md:items-center">
                              <div className="text-center">
                                <p className="text-xs text-zinc-500">
                                  Principal
                                </p>
                                <p className="font-medium">
                                  ${investment.amount}
                                </p>
                              </div>
                              <div className="text-center">
                                <p className="text-xs text-zinc-500">
                                  PHYR Tokens
                                </p>
                                <p className="font-medium">
                                  {investment.tokens}
                                </p>
                              </div>
                              <div className="text-center">
                                <p className="text-xs text-zinc-500">
                                  Interest Earned
                                </p>
                                <p className="font-medium text-green-400">
                                  ${investment.interest}
                                </p>
                              </div>
                              <div>
                                <Button
                                  size="sm"
                                  variant="outline"
                                  className="w-full border-purple-800 bg-transparent hover:bg-purple-900/20"
                                  onClick={() => setShowWithdrawDialog(true)}
                                >
                                  Withdraw Interest
                                </Button>
                              </div>
                            </div>
                          </div>
                        </motion.div>
                      ))}
                    </div>

                    {investments.length === 0 && (
                      <div className="flex flex-col items-center justify-center py-12">
                        <p className="text-zinc-500">
                          You don't have any active investments
                        </p>
                        <Button
                          className="mt-4 bg-gradient-to-r from-purple-700 to-purple-600 hover:from-purple-600 hover:to-purple-500"
                          onClick={() => setShowNewInvestmentDialog(true)}
                        >
                          <Plus className="mr-2 h-4 w-4" /> Create Your First
                          Investment
                        </Button>
                      </div>
                    )}
                  </div>
                </TabsContent>

                <TabsContent value="analytics" className="mt-6">
                  <div className="grid gap-6 lg:grid-cols-2">
                    <Card className="border-zinc-800 bg-gradient-to-b from-zinc-900/50 to-black">
                      <CardHeader>
                        <CardTitle className="flex items-center justify-between">
                          Interest Growth
                          <Button
                            variant="ghost"
                            size="icon"
                            className="h-8 w-8 text-zinc-400 hover:text-white"
                          >
                            <LineChart className="h-4 w-4" />
                          </Button>
                        </CardTitle>
                      </CardHeader>
                      <CardContent>
                        <div className="h-[240px] w-full">
                          {/* Chart placeholder */}
                          <div className="flex h-full flex-col items-center justify-center rounded-md border border-dashed border-zinc-800">
                            <LineChart className="h-8 w-8 text-purple-500" />
                            <p className="mt-2 text-sm text-zinc-500">
                              Interest growth visualization
                            </p>
                          </div>
                        </div>
                      </CardContent>
                    </Card>

                    <Card className="border-zinc-800 bg-gradient-to-b from-zinc-900/50 to-black">
                      <CardHeader>
                        <CardTitle>Recent Activity</CardTitle>
                      </CardHeader>
                      <CardContent>
                        <div className="space-y-4">
                          {[
                            {
                              type: "Interest",
                              amount: "+$12.50",
                              time: "2 hours ago",
                              pool: "Stable Yield",
                            },
                            {
                              type: "Investment",
                              amount: "+$2,000.00",
                              time: "2 days ago",
                              pool: "Growth Fund",
                            },
                            {
                              type: "Withdrawal",
                              amount: "-$150.00",
                              time: "5 days ago",
                              pool: "Stable Yield",
                            },
                            {
                              type: "Interest",
                              amount: "+$45.75",
                              time: "1 week ago",
                              pool: "Growth Fund",
                            },
                          ].map((activity, i) => (
                            <motion.div
                              key={i}
                              initial={{ opacity: 0, x: -10 }}
                              animate={{ opacity: 1, x: 0 }}
                              transition={{ duration: 0.3, delay: 0.05 * i }}
                              className="flex items-center justify-between rounded-lg border border-zinc-800 bg-zinc-900/30 p-3"
                            >
                              <div className="flex items-center gap-3">
                                <div
                                  className={`flex h-8 w-8 items-center justify-center rounded-full ${
                                    activity.type === "Interest"
                                      ? "bg-green-900/30 text-green-400"
                                      : activity.type === "Investment"
                                        ? "bg-purple-900/30 text-purple-400"
                                        : "bg-red-900/30 text-red-400"
                                  }`}
                                >
                                  {activity.type === "Interest" ? (
                                    <DollarSign className="h-4 w-4" />
                                  ) : activity.type === "Investment" ? (
                                    <ArrowUpRight className="h-4 w-4" />
                                  ) : (
                                    <ChevronDown className="h-4 w-4" />
                                  )}
                                </div>
                                <div>
                                  <p className="font-medium">{activity.type}</p>
                                  <p className="text-xs text-zinc-500">
                                    {activity.pool}
                                  </p>
                                </div>
                              </div>
                              <div className="text-right">
                                <p
                                  className={`font-medium ${
                                    activity.amount.startsWith("+")
                                      ? "text-green-400"
                                      : "text-red-400"
                                  }`}
                                >
                                  {activity.amount}
                                </p>
                                <p className="flex items-center text-xs text-zinc-500">
                                  <Clock className="mr-1 h-3 w-3" />{" "}
                                  {activity.time}
                                </p>
                              </div>
                            </motion.div>
                          ))}
                        </div>
                      </CardContent>
                    </Card>
                  </div>
                </TabsContent>
              </Tabs>
            </motion.div>

            {/* Interest Accrual Card */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5, delay: 0.3 }}
            >
              <Card className="border-purple-800/30 bg-gradient-to-br from-purple-900/20 to-black">
                <CardContent className="p-6">
                  <div className="flex flex-col items-center justify-between gap-4 md:flex-row">
                    <div>
                      <h3 className="text-lg font-medium">
                        Pending Interest Available
                      </h3>
                      <p className="text-sm text-zinc-400">
                        You have earned interest that can be withdrawn
                      </p>
                    </div>
                    <div className="flex items-center gap-4">
                      <div className="text-center">
                        <p className="text-3xl font-bold text-purple-300">
                          ${stats.pendingInterest}
                        </p>
                        <p className="text-xs text-zinc-500">
                          Available to withdraw
                        </p>
                      </div>
                      <Button
                        className="bg-gradient-to-r from-purple-700 to-purple-600 hover:from-purple-600 hover:to-purple-500"
                        onClick={() => setShowWithdrawDialog(true)}
                      >
                        <Wallet className="mr-2 h-4 w-4" /> Withdraw Now
                      </Button>
                    </div>
                  </div>
                </CardContent>
              </Card>
            </motion.div>
          </motion.div>
        </main>
      </div>
    </>
  );
}
