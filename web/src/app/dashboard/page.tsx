"use client";
import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { getLoggedInUser, logout } from "@/lib/appwrite";
import BlurText from "@/components/BlurText/BlurText";
import Navbar from "@/components/Navbar";

export default function Dashboard() {
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

  return (
    <div className="flex flex-col justify-center text-white">
      <div className="absolute inset-0 overflow-hidden">
        <div className="absolute -left-[250px] -right-[300px] h-[600px] w-[600px] rounded-full bg-purple-600/20 blur-[120px]" />
        <div className="absolute -bottom-[700px] -left-[300px] h-[600px] w-[600px] rounded-full bg-purple-600/10 blur-[120px]" />
      </div>

      <BlurText
        text={`Hey ${username}, ${greeting}!`}
        delay={150}
        animateBy="words"
        direction="top"
        className="mb-4 text-4xl font-bold m-8"
      />
    </div>
  );
}
