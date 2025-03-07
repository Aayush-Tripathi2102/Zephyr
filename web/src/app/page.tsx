"use client"

import Link from "next/link"
import Image from "next/image"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { ArrowRight, Shield, Zap, Globe, RefreshCw, Users, Menu, X } from "lucide-react"
import { useState } from "react"
import Navbar from "@/components/Navbar"

export default function LandingPage() {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false)

  return (
    <div className="min-h-screen bg-black text-white flex flex-col">
      <Navbar/>
      <main>
        {/* Hero Section */}
        <section className="relative overflow-hidden">
          {/* Background Elements */}
          <div className="absolute inset-0 overflow-hidden">
            <div className="absolute -top-[300px] -right-[300px] w-[600px] h-[600px] bg-purple-600/20 rounded-full blur-[120px]" />
            <div className="absolute -bottom-[300px] -left-[300px] w-[600px] h-[600px] bg-purple-600/10 rounded-full blur-[120px]" />
          </div>

          <div className="container mx-auto px-4 py-20 md:py-32 relative z-10">
            <div className="max-w-3xl mx-auto text-center mb-12">
              <div className="inline-block px-3 py-1 rounded-full bg-purple-900/30 text-purple-400 text-xs font-medium mb-6">
                Decentralized Lending Protocol
              </div>
              <h1 className="text-4xl md:text-6xl font-bold mb-6 bg-clip-text text-transparent bg-gradient-to-r from-white to-purple-200">
                Borrow & Lend Without Intermediaries
              </h1>
              <p className="text-lg md:text-xl text-gray-400 mb-8">
                A fully decentralized platform that connects borrowers and lenders directly, eliminating middlemen and
                reducing costs through smart contracts.
              </p>
              <div className="flex flex-col sm:flex-row gap-4 justify-center">
                <Button className="bg-purple-600 hover:bg-purple-700 text-white px-8 py-6 h-auto text-lg">
                  Launch App
                  <ArrowRight className="ml-2 h-5 w-5" />
                </Button>
                <Button
                  variant="outline"
                  className="border-purple-500 text-purple-400 hover:bg-purple-500/10 px-8 py-6 h-auto text-lg"
                >
                  Learn More
                </Button>
              </div>
            </div>

            <div className="relative mx-auto max-w-4xl mt-16 rounded-xl overflow-hidden border border-purple-900/30 shadow-2xl shadow-purple-900/20">
              <Image
                src="/placeholder.svg?height=600&width=1200"
                width={1200}
                height={600}
                alt="Platform Dashboard"
                className="w-full h-auto"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-black/80 to-transparent" />
            </div>
          </div>
        </section>

        {/* Stats Section */}
        <section className="border-y border-purple-900/20 bg-black/80 backdrop-blur-sm">
          <div className="container mx-auto px-4 py-12">
            <div className="grid grid-cols-2 md:grid-cols-4 gap-8">
              <div className="text-center">
                <p className="text-3xl md:text-4xl font-bold text-white mb-2">$240M+</p>
                <p className="text-sm text-gray-400">Total Value Locked</p>
              </div>
              <div className="text-center">
                <p className="text-3xl md:text-4xl font-bold text-white mb-2">45K+</p>
                <p className="text-sm text-gray-400">Active Users</p>
              </div>
              <div className="text-center">
                <p className="text-3xl md:text-4xl font-bold text-white mb-2">12K+</p>
                <p className="text-sm text-gray-400">Loans Funded</p>
              </div>
              <div className="text-center">
                <p className="text-3xl md:text-4xl font-bold text-white mb-2">5</p>
                <p className="text-sm text-gray-400">Blockchain Networks</p>
              </div>
            </div>
          </div>
        </section>

        {/* Features Section */}
        <section id="features" className="py-20 md:py-32 relative overflow-hidden">
          <div className="absolute inset-0 overflow-hidden">
            <div className="absolute top-[100px] -left-[300px] w-[600px] h-[600px] bg-purple-600/10 rounded-full blur-[120px]" />
          </div>

          <div className="container mx-auto px-4 relative z-10">
            <div className="max-w-3xl mx-auto text-center mb-16">
              <h2 className="text-3xl md:text-4xl font-bold mb-6">Why Choose Zephyr?</h2>
              <p className="text-gray-400 text-lg">
                Our platform offers unique advantages that traditional financial institutions can't match.
              </p>
            </div>

            <div className="grid md:grid-cols-3 gap-8">
              <div className="bg-gradient-to-b from-purple-900/20 to-transparent p-8 rounded-2xl border border-purple-900/30 backdrop-blur-sm">
                <div className="w-12 h-12 rounded-xl bg-purple-600/20 flex items-center justify-center mb-6">
                  <Shield className="text-purple-400" />
                </div>
                <h3 className="text-xl font-bold mb-3">Trustless Security</h3>
                <p className="text-gray-400">
                  Smart contracts automatically enforce loan terms without requiring trust between parties.
                </p>
              </div>

              <div className="bg-gradient-to-b from-purple-900/20 to-transparent p-8 rounded-2xl border border-purple-900/30 backdrop-blur-sm">
                <div className="w-12 h-12 rounded-xl bg-purple-600/20 flex items-center justify-center mb-6">
                  <Zap className="text-purple-400" />
                </div>
                <h3 className="text-xl font-bold mb-3">Lower Fees</h3>
                <p className="text-gray-400">
                  By removing intermediaries, we drastically reduce fees compared to traditional lending.
                </p>
              </div>

              <div className="bg-gradient-to-b from-purple-900/20 to-transparent p-8 rounded-2xl border border-purple-900/30 backdrop-blur-sm">
                <div className="w-12 h-12 rounded-xl bg-purple-600/20 flex items-center justify-center mb-6">
                  <Globe className="text-purple-400" />
                </div>
                <h3 className="text-xl font-bold mb-3">Global Access</h3>
                <p className="text-gray-400">
                  Anyone with an internet connection can access loans, regardless of location or credit history.
                </p>
              </div>
            </div>
          </div>
        </section>

        {/* How It Works Section */}
        <section id="how-it-works" className="py-20 md:py-32 bg-black/80 border-y border-purple-900/20">
          <div className="container mx-auto px-4">
            <div className="max-w-3xl mx-auto text-center mb-16">
              <h2 className="text-3xl md:text-4xl font-bold mb-6">How Zephyr Works</h2>
              <p className="text-gray-400 text-lg">
                Our platform simplifies the lending process through blockchain technology.
              </p>
            </div>

            <div className="grid md:grid-cols-2 gap-16 items-center">
              <div>
                <div className="space-y-12">
                  <div className="flex gap-6">
                    <div className="flex-shrink-0">
                      <div className="w-10 h-10 rounded-full bg-purple-600 flex items-center justify-center text-white font-bold">
                        1
                      </div>
                    </div>
                    <div>
                      <h3 className="text-xl font-bold mb-2">Connect Your Wallet</h3>
                      <p className="text-gray-400">
                        Link your cryptocurrency wallet to our platform with a single click.
                      </p>
                    </div>
                  </div>

                  <div className="flex gap-6">
                    <div className="flex-shrink-0">
                      <div className="w-10 h-10 rounded-full bg-purple-600 flex items-center justify-center text-white font-bold">
                        2
                      </div>
                    </div>
                    <div>
                      <h3 className="text-xl font-bold mb-2">Choose Your Role</h3>
                      <p className="text-gray-400">
                        Decide whether you want to borrow funds or provide liquidity as a lender.
                      </p>
                    </div>
                  </div>

                  <div className="flex gap-6">
                    <div className="flex-shrink-0">
                      <div className="w-10 h-10 rounded-full bg-purple-600 flex items-center justify-center text-white font-bold">
                        3
                      </div>
                    </div>
                    <div>
                      <h3 className="text-xl font-bold mb-2">Set Your Terms</h3>
                      <p className="text-gray-400">
                        Define interest rates, loan duration, and collateral requirements.
                      </p>
                    </div>
                  </div>

                  <div className="flex gap-6">
                    <div className="flex-shrink-0">
                      <div className="w-10 h-10 rounded-full bg-purple-600 flex items-center justify-center text-white font-bold">
                        4
                      </div>
                    </div>
                    <div>
                      <h3 className="text-xl font-bold mb-2">Execute Smart Contract</h3>
                      <p className="text-gray-400">
                        Once terms are agreed upon, the smart contract automatically handles the transaction.
                      </p>
                    </div>
                  </div>
                </div>
              </div>

              <div className="relative">
                <div className="absolute -inset-0.5 bg-gradient-to-r from-purple-600 to-purple-400 rounded-2xl blur opacity-30"></div>
                <div className="relative rounded-2xl overflow-hidden border border-purple-900/30">
                  <Image
                    src="/placeholder.svg?height=600&width=800"
                    width={800}
                    height={600}
                    alt="How DefiLend Works"
                    className="w-full h-auto"
                  />
                </div>
              </div>
            </div>
          </div>
        </section>

        {/* Security Section */}
        <section id="security" className="py-20 md:py-32 relative overflow-hidden">
          <div className="absolute inset-0 overflow-hidden">
            <div className="absolute -bottom-[300px] -right-[300px] w-[600px] h-[600px] bg-purple-600/10 rounded-full blur-[120px]" />
          </div>

          <div className="container mx-auto px-4 relative z-10">
            <div className="max-w-3xl mx-auto text-center mb-16">
              <h2 className="text-3xl md:text-4xl font-bold mb-6">Enterprise-Grade Security</h2>
              <p className="text-gray-400 text-lg">Your assets are protected by industry-leading security measures.</p>
            </div>

            <div className="grid md:grid-cols-2 gap-16 items-center">
              <div className="order-2 md:order-1">
                <div className="relative">
                  <div className="absolute -inset-0.5 bg-gradient-to-r from-purple-600 to-purple-400 rounded-2xl blur opacity-30"></div>
                  <div className="relative rounded-2xl overflow-hidden border border-purple-900/30">
                    <Image
                      src="/placeholder.svg?height=600&width=800"
                      width={800}
                      height={600}
                      alt="Security Visualization"
                      className="w-full h-auto"
                    />
                  </div>
                </div>
              </div>

              <div className="order-1 md:order-2">
                <div className="space-y-8">
                  <div className="bg-gradient-to-r from-purple-900/20 to-transparent p-6 rounded-xl border border-purple-900/30">
                    <h3 className="text-xl font-bold mb-2">Audited Smart Contracts</h3>
                    <p className="text-gray-400">
                      All our smart contracts undergo rigorous security audits by leading blockchain security firms.
                    </p>
                  </div>

                  <div className="bg-gradient-to-r from-purple-900/20 to-transparent p-6 rounded-xl border border-purple-900/30">
                    <h3 className="text-xl font-bold mb-2">Decentralized Architecture</h3>
                    <p className="text-gray-400">
                      Our platform operates on a fully decentralized network, eliminating single points of failure.
                    </p>
                  </div>

                  <div className="bg-gradient-to-r from-purple-900/20 to-transparent p-6 rounded-xl border border-purple-900/30">
                    <h3 className="text-xl font-bold mb-2">Insurance Fund</h3>
                    <p className="text-gray-400">
                      A portion of all fees goes to an insurance fund that protects users against unexpected events.
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>

        {/* Community Section */}
        <section id="community" className="py-20 md:py-32 bg-black/80 border-y border-purple-900/20">
          <div className="container mx-auto px-4">
            <div className="max-w-3xl mx-auto text-center mb-16">
              <h2 className="text-3xl md:text-4xl font-bold mb-6">Join Our Community</h2>
              <p className="text-gray-400 text-lg">
                Be part of a growing ecosystem of borrowers, lenders, and DeFi enthusiasts.
              </p>
            </div>

            <div className="grid md:grid-cols-3 gap-8">
              <div className="bg-gradient-to-b from-purple-900/20 to-transparent p-8 rounded-2xl border border-purple-900/30 backdrop-blur-sm text-center">
                <div className="w-16 h-16 mx-auto rounded-full bg-purple-600/20 flex items-center justify-center mb-6">
                  <Users className="text-purple-400 h-8 w-8" />
                </div>
                <h3 className="text-xl font-bold mb-3">45,000+ Members</h3>
                <p className="text-gray-400 mb-6">
                  Join thousands of users already benefiting from decentralized lending.
                </p>
                <Button variant="outline" className="border-purple-500 text-purple-400 hover:bg-purple-500/10">
                  Join Discord
                </Button>
              </div>

              <div className="bg-gradient-to-b from-purple-900/20 to-transparent p-8 rounded-2xl border border-purple-900/30 backdrop-blur-sm text-center">
                <div className="w-16 h-16 mx-auto rounded-full bg-purple-600/20 flex items-center justify-center mb-6">
                  <svg
                    className="text-purple-400 h-8 w-8"
                    viewBox="0 0 24 24"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M23 3.00005C22.0424 3.67552 20.9821 4.19216 19.86 4.53005C19.2577 3.83756 18.4573 3.34674 17.567 3.12397C16.6767 2.90121 15.7395 2.95724 14.8821 3.2845C14.0247 3.61176 13.2884 4.19445 12.773 4.95376C12.2575 5.71308 11.9877 6.61238 12 7.53005V8.53005C10.2426 8.57561 8.50127 8.18586 6.93101 7.39549C5.36074 6.60513 4.01032 5.43868 3 4.00005C3 4.00005 -1 13 8 17C5.94053 18.398 3.48716 19.099 1 19C10 24 21 19 21 7.50005C20.9991 7.2215 20.9723 6.94364 20.92 6.67005C21.9406 5.66354 22.6608 4.39276 23 3.00005Z"
                      stroke="currentColor"
                      strokeWidth="2"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                    />
                  </svg>
                </div>
                <h3 className="text-xl font-bold mb-3">Latest Updates</h3>
                <p className="text-gray-400 mb-6">
                  Follow us on Twitter for the latest news, updates, and announcements.
                </p>
                <Button variant="outline" className="border-purple-500 text-purple-400 hover:bg-purple-500/10">
                  Follow on Twitter
                </Button>
              </div>

              <div className="bg-gradient-to-b from-purple-900/20 to-transparent p-8 rounded-2xl border border-purple-900/30 backdrop-blur-sm text-center">
                <div className="w-16 h-16 mx-auto rounded-full bg-purple-600/20 flex items-center justify-center mb-6">
                  <svg
                    className="text-purple-400 h-8 w-8"
                    viewBox="0 0 24 24"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M12 22C17.5228 22 22 17.5228 22 12C22 6.47715 17.5228 2 12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22Z"
                      stroke="currentColor"
                      strokeWidth="2"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                    />
                    <path
                      d="M2 12H22"
                      stroke="currentColor"
                      strokeWidth="2"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                    />
                    <path
                      d="M12 2C14.5013 4.73835 15.9228 8.29203 16 12C15.9228 15.708 14.5013 19.2616 12 22C9.49872 19.2616 8.07725 15.708 8 12C8.07725 8.29203 9.49872 4.73835 12 2Z"
                      stroke="currentColor"
                      strokeWidth="2"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                    />
                  </svg>
                </div>
                <h3 className="text-xl font-bold mb-3">Documentation</h3>
                <p className="text-gray-400 mb-6">
                  Explore our comprehensive guides, tutorials, and API documentation.
                </p>
                <Button variant="outline" className="border-purple-500 text-purple-400 hover:bg-purple-500/10">
                  Read Docs
                </Button>
              </div>
            </div>
          </div>
        </section>

        {/* CTA Section */}
        <section className="py-20 md:py-32 relative overflow-hidden">
          <div className="absolute inset-0 overflow-hidden">
            <div className="absolute top-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-purple-500 to-transparent" />
            <div className="absolute -top-[300px] -left-[300px] w-[600px] h-[600px] bg-purple-600/20 rounded-full blur-[120px]" />
            <div className="absolute -bottom-[300px] -right-[300px] w-[600px] h-[600px] bg-purple-600/20 rounded-full blur-[120px]" />
          </div>

          <div className="container mx-auto px-4 relative z-10">
            <div className="max-w-4xl mx-auto bg-gradient-to-b from-purple-900/30 to-purple-900/10 p-8 md:p-12 rounded-3xl border border-purple-500/30 backdrop-blur-sm">
              <div className="grid md:grid-cols-2 gap-8 items-center">
                <div>
                  <h2 className="text-3xl md:text-4xl font-bold mb-4">Ready to Get Started?</h2>
                  <p className="text-gray-300 mb-6">
                    Join thousands of users already benefiting from decentralized P2P lending. Launch the app or join
                    our waitlist for early access.
                  </p>
                  <div className="flex flex-col sm:flex-row gap-4">
                    <Button className="bg-purple-600 hover:bg-purple-700 text-white">
                      Launch App
                      <ArrowRight className="ml-2 h-5 w-5" />
                    </Button>
                    <Button variant="outline" className="border-purple-500 text-purple-400 hover:bg-purple-500/10">
                      Join Waitlist
                    </Button>
                  </div>
                </div>

                <div className="bg-black/40 p-6 rounded-xl border border-purple-900/30">
                  <h3 className="text-xl font-bold mb-4">Stay Updated</h3>
                  <p className="text-gray-400 mb-4">
                    Subscribe to our newsletter for the latest updates and announcements.
                  </p>
                  <form className="space-y-4">
                    <Input
                      type="email"
                      placeholder="Enter your email"
                      className="bg-black/50 border-purple-900/50 focus:border-purple-500 text-white"
                    />
                    <Button className="w-full bg-purple-600 hover:bg-purple-700 text-white">Subscribe</Button>
                  </form>
                </div>
              </div>
            </div>
          </div>
        </section>
      </main>

      {/* Footer */}
      <footer className="bg-black/90 border-t border-purple-900/20 pt-16 pb-8">
        <div className="container mx-auto px-4">
          <div className="grid grid-cols-2 md:grid-cols-5 gap-8 mb-12">
            <div className="col-span-2">
              <Link href="/" className="flex items-center gap-2 mb-4">
                <div className="w-8 h-8 rounded-full bg-gradient-to-r from-purple-600 to-purple-400 flex items-center justify-center">
                  <RefreshCw size={18} className="text-white" />
                </div>
                <span className="font-bold text-xl">DefiLend</span>
              </Link>
              <p className="text-gray-400 mb-4 max-w-xs">
                A decentralized P2P lending platform connecting borrowers and lenders directly through smart contracts.
              </p>
              <div className="flex gap-4">
                <a href="#" className="text-gray-400 hover:text-purple-400 transition-colors">
                  <svg className="h-5 w-5" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                    <path
                      fillRule="evenodd"
                      d="M22 12c0-5.523-4.477-10-10-10S2 6.477 2 12c0 4.991 3.657 9.128 8.438 9.878v-6.987h-2.54V12h2.54V9.797c0-2.506 1.492-3.89 3.777-3.89 1.094 0 2.238.195 2.238.195v2.46h-1.26c-1.243 0-1.63.771-1.63 1.562V12h2.773l-.443 2.89h-2.33v6.988C18.343 21.128 22 16.991 22 12z"
                      clipRule="evenodd"
                    />
                  </svg>
                </a>
                <a href="#" className="text-gray-400 hover:text-purple-400 transition-colors">
                  <svg className="h-5 w-5" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M8.29 20.251c7.547 0 11.675-6.253 11.675-11.675 0-.178 0-.355-.012-.53A8.348 8.348 0 0022 5.92a8.19 8.19 0 01-2.357.646 4.118 4.118 0 001.804-2.27 8.224 8.224 0 01-2.605.996 4.107 4.107 0 00-6.993 3.743 11.65 11.65 0 01-8.457-4.287 4.106 4.106 0 001.27 5.477A4.072 4.072 0 012.8 9.713v.052a4.105 4.105 0 003.292 4.022 4.095 4.095 0 01-1.853.07 4.108 4.108 0 003.834 2.85A8.233 8.233 0 012 18.407a11.616 11.616 0 006.29 1.84" />
                  </svg>
                </a>
                <a href="#" className="text-gray-400 hover:text-purple-400 transition-colors">
                  <svg className="h-5 w-5" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                    <path
                      fillRule="evenodd"
                      d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z"
                      clipRule="evenodd"
                    />
                  </svg>
                </a>
                <a href="#" className="text-gray-400 hover:text-purple-400 transition-colors">
                  <svg className="h-5 w-5" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                    <path
                      fillRule="evenodd"
                      d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10c5.51 0 10-4.48 10-10S17.51 2 12 2zm6.605 4.61a8.502 8.502 0 011.93 5.314c-.281-.054-3.101-.629-5.943-.271-.065-.141-.12-.293-.184-.445a25.416 25.416 0 00-.564-1.236c3.145-1.28 4.577-3.124 4.761-3.362zM12 3.475c2.17 0 4.154.813 5.662 2.148-.152.216-1.443 1.941-4.48 3.08-1.399-2.57-2.95-4.675-3.189-5A8.687 8.687 0 0112 3.475zm-3.633.803a53.896 53.896 0 013.167 4.935c-3.992 1.063-7.517 1.04-7.896 1.04a8.581 8.581 0 014.729-5.975zM3.453 12.01v-.26c.37.01 4.512.065 8.775-1.215.25.477.477.965.694 1.453-.109.033-.228.065-.336.098-4.404 1.42-6.747 5.303-6.942 5.629a8.522 8.522 0 01-2.19-5.705zM12 20.547a8.482 8.482 0 01-5.239-1.8c.152-.315 1.888-3.656 6.703-5.337.022-.01.033-.01.054-.022a35.318 35.318 0 011.823 6.475 8.4 8.4 0 01-3.341.684zm4.761-1.465c-.086-.52-.542-3.015-1.659-6.084 2.679-.423 5.022.271 5.314.369a8.468 8.468 0 01-3.655 5.715z"
                      clipRule="evenodd"
                    />
                  </svg>
                </a>
              </div>
            </div>

            <div>
              <h3 className="font-bold text-lg mb-4">Product</h3>
              <ul className="space-y-3">
                <li>
                  <Link href="#" className="text-gray-400 hover:text-purple-400 transition-colors">
                    Features
                  </Link>
                </li>
                <li>
                  <Link href="#" className="text-gray-400 hover:text-purple-400 transition-colors">
                    How It Works
                  </Link>
                </li>
                <li>
                  <Link href="#" className="text-gray-400 hover:text-purple-400 transition-colors">
                    Pricing
                  </Link>
                </li>
                <li>
                  <Link href="#" className="text-gray-400 hover:text-purple-400 transition-colors">
                    Use Cases
                  </Link>
                </li>
              </ul>
            </div>

            <div>
              <h3 className="font-bold text-lg mb-4">Resources</h3>
              <ul className="space-y-3">
                <li>
                  <Link href="#" className="text-gray-400 hover:text-purple-400 transition-colors">
                    Documentation
                  </Link>
                </li>
                <li>
                  <Link href="#" className="text-gray-400 hover:text-purple-400 transition-colors">
                    Guides
                  </Link>
                </li>
                <li>
                  <Link href="#" className="text-gray-400 hover:text-purple-400 transition-colors">
                    API Reference
                  </Link>
                </li>
                <li>
                  <Link href="#" className="text-gray-400 hover:text-purple-400 transition-colors">
                    Blog
                  </Link>
                </li>
              </ul>
            </div>

            <div>
              <h3 className="font-bold text-lg mb-4">Company</h3>
              <ul className="space-y-3">
                <li>
                  <Link href="#" className="text-gray-400 hover:text-purple-400 transition-colors">
                    About
                  </Link>
                </li>
                <li>
                  <Link href="#" className="text-gray-400 hover:text-purple-400 transition-colors">
                    Careers
                  </Link>
                </li>
                <li>
                  <Link href="#" className="text-gray-400 hover:text-purple-400 transition-colors">
                    Press
                  </Link>
                </li>
                <li>
                  <Link href="#" className="text-gray-400 hover:text-purple-400 transition-colors">
                    Contact
                  </Link>
                </li>
              </ul>
            </div>
          </div>

          <div className="border-t border-purple-900/20 pt-8">
            <div className="flex flex-col md:flex-row justify-between items-center">
              <p className="text-gray-500 text-sm mb-4 md:mb-0">
                &copy; {new Date().getFullYear()} DefiLend. All rights reserved.
              </p>
              <div className="flex gap-6">
                <Link href="#" className="text-gray-500 hover:text-purple-400 text-sm transition-colors">
                  Privacy Policy
                </Link>
                <Link href="#" className="text-gray-500 hover:text-purple-400 text-sm transition-colors">
                  Terms of Service
                </Link>
                <Link href="#" className="text-gray-500 hover:text-purple-400 text-sm transition-colors">
                  Cookie Policy
                </Link>
              </div>
            </div>
          </div>
        </div>
      </footer>
    </div>
  )
}

