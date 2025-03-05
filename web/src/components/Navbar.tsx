"use client";
import Image from "next/image";
import Link from "next/link";
import React, { useState, useEffect } from "react";
import { Button } from "./ui/button";
import { Menu, X } from "lucide-react";
import { getLoggedInUser, logout } from "@/lib/appwrite";
import { useRouter } from "next/navigation";

const Navbar = () => {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const router = useRouter();

  useEffect(() => {
    const checkUser = async () => {
      const user = await getLoggedInUser();
      setIsLoggedIn(!!user);
    };
    checkUser();
  }, []);

  const handleLogout = async () => {
    await logout();
    setIsLoggedIn(false);
    router.push("/login");
  };

  return (
    <header className="sticky top-0 z-50 border-b border-purple-900/20 bg-black/80 backdrop-blur-sm">
      <div className="container mx-auto flex items-center justify-between px-4 py-4">
        <Link href="/" className="flex items-end gap-0">
          <Image src="/zephyrIcon.png" width={40} height={40} alt="logo" />
          <span className="text-xl font-bold">ephyr</span>
        </Link>

        {/* Desktop Navigation */}

        <div className="hidden items-center gap-4 md:flex">
          {isLoggedIn ? (
            <Button
              onClick={handleLogout}
              variant="outline"
              className="border-red-500 text-red-400 hover:bg-red-500/10"
            >
              Logout
            </Button>
          ) : (
            <>
              <Button
                variant="outline"
                onClick={() => {
                  router.push("/signup");
                }}
                className="border-purple-500 text-purple-400 hover:bg-purple-500/10"
              >
                Sign In
              </Button>
              <Button onClick={()=>{router.push('/login')}} className="bg-purple-600 text-white hover:bg-purple-700">
                Log in
              </Button>
            </>
          )}
        </div>

        {/* Mobile menu button */}
        <button
          className="text-gray-300 md:hidden"
          onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
        >
          {mobileMenuOpen ? <X size={24} /> : <Menu size={24} />}
        </button>
      </div>

      {/* Mobile Navigation */}
      {mobileMenuOpen && (
        <div className="border-b border-purple-900/20 bg-black/95 py-4 md:hidden">
          <nav className="container mx-auto flex flex-col gap-4 px-4">
            <Link
              href="#features"
              className="py-2 text-gray-300 transition-colors hover:text-purple-400"
              onClick={() => setMobileMenuOpen(false)}
            >
              Features
            </Link>
            <Link
              href="#how-it-works"
              className="py-2 text-gray-300 transition-colors hover:text-purple-400"
              onClick={() => setMobileMenuOpen(false)}
            >
              How It Works
            </Link>
            <Link
              href="#security"
              className="py-2 text-gray-300 transition-colors hover:text-purple-400"
              onClick={() => setMobileMenuOpen(false)}
            >
              Security
            </Link>
            <Link
              href="#community"
              className="py-2 text-gray-300 transition-colors hover:text-purple-400"
              onClick={() => setMobileMenuOpen(false)}
            >
              Community
            </Link>
            <div className="flex flex-col gap-3 border-t border-purple-900/20 pt-3">
              {isLoggedIn ? (
                <Button
                  onClick={handleLogout}
                  variant="outline"
                  className="w-full border-red-500 text-red-400 hover:bg-red-500/10"
                >
                  Logout
                </Button>
              ) : (
                <>
                  <Button
                    variant="outline"
                    onClick={() => {
                      router.push("/signup");
                    }}
                    className="w-full border-purple-500 text-purple-400 hover:bg-purple-500/10"
                  >
                    Sign In
                  </Button>
                  <Button
                    onClick={() => {
                      router.push("/login");
                    }}
                    className="w-full bg-purple-600 text-white hover:bg-purple-700"
                  >
                    Log in
                  </Button>
                </>
              )}
            </div>
          </nav>
        </div>
      )}
    </header>
  );
};

export default Navbar;
