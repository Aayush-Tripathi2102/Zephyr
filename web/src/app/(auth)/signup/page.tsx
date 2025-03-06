"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";
import { register } from "@/lib/appwrite";
import Link from "next/link";
import Image from "next/image";

export default function Signup() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [name, setName] = useState("");
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState("");
  const router = useRouter();

  const handleSignup = async () => {
    setLoading(true);
    setMessage("");
    const success = await register(email, password, name);
    if (success) {
      router.push("/dashboard");
    } else {
      setMessage("Signup failed.");
      setLoading(false);
    }
  };

  return (
    <div className="flex">
      <div className="w-1/2 relative">
        <div className="absolute inset-0 overflow-hidden">
          <div className="absolute -left-[300px] -top-[300px] h-[600px] w-[600px] rounded-full bg-purple-600/20 blur-[120px]" />
          <div className="absolute -bottom-[300px] -left-[300px] h-[600px] w-[600px] rounded-full bg-purple-600/10 blur-[120px]" />
        </div>
        <div className="flex min-h-screen flex-col items-center justify-center p-4">
          <div className="w-[500px] mx-auto bg-gradient-to-b from-purple-900/30 to-purple-900/10 p-8 md:p-12 rounded-3xl border border-purple-500/30 backdrop-blur-sm">
            <h1 className="mb-6 py-2 bg-gradient-to-r from-white to-purple-200 bg-clip-text text-4xl font-bold text-transparent md:text-6xl">
              Sign up
            </h1>
            <h2 className="text-[#636363] py-2">Fill the form and be part of the best Decentralised P2P out there</h2>
            <input
              type="text"
              placeholder="Name"
              value={name}
              onChange={(e) => setName(e.target.value)}
              className="mb-2 w-full rounded-xl border-purple-500/30 bg-transparent border p-2 text-white placeholder:text-gray-400"
            />
            <input
              type="email"
              placeholder="Email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="mb-2 w-full rounded-xl border-purple-500/30 bg-transparent border p-2 text-white placeholder:text-gray-400"
            />
            <input
              type="password"
              placeholder="Password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="mb-2 w-full rounded-xl border-purple-500/30 bg-transparent border p-2 text-white placeholder:text-gray-400"
            />
            <button
              onClick={handleSignup}
              disabled={loading}
              className="w-full rounded-full mt-3 py-2 bg-purple-500/30 p-2 text-white hover:bg-purple-600/20"
            >
              {loading ? "Signing up..." : "Sign Up"}
            </button>
            {message && (
              <p className="mt-2 text-center text-red-500">{message}</p>
            )}
            <p className="mt-4 text-center text-[#636363]">
              Already part of the network? <Link href="/login" className="text-purple-700 hover:underline">Log In</Link>
            </p>
          </div>
        </div>
      </div>
      <div className="w-1/2 h-screen relative">
        <Image src='/bg.webp' layout="fill" objectFit="cover" alt="bg" />
      </div>
    </div>
  );
}
