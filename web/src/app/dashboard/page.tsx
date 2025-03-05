// pages/dashboard.tsx
"use client";
import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { getLoggedInUser, logout } from "@/lib/appwrite";
import BlurText from "@/components/BlurText/BlurText";

export default function Dashboard() {
  const [username, setUsername] = useState("");
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

  const handleLogout = async () => {
    await logout();
    router.push("/login");
  };

  return (
    <div className="flex min-h-screen flex-col items-center justify-center bg-gray-900 text-white">
      {/* <h1 className="text-4xl font-bold mb-4">Hey {username}, Good Morning!</h1> */}

      <BlurText
        text={`Hey ${username}, Good Morning!`}
        delay={150}
        animateBy="words"
        direction="top"
        className="text-4xl font-bold mb-4"
      />
      <button
        onClick={handleLogout}
        className="mt-4 rounded-lg bg-red-500 px-4 py-2 hover:bg-red-600"
      >
        Logout
      </button>
    </div>
  );
}
