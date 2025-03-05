import { Client, Account, ID } from "appwrite";

const client = new Client();

client
  .setEndpoint(process.env.NEXT_PUBLIC_APPWRITE_ENDPOINT!)
  .setProject(process.env.NEXT_PUBLIC_APPWRITE_PROJECT_ID!);

const account = new Account(client);

export async function register(email: string, password: string, name: string): Promise<boolean> {
  try {
    await account.create(ID.unique(), email, password, name);
    await login(email, password);
    return true;
  } catch (error: any) {
    console.error("Registration failed:", error.message);
    return false;
  }
}

export async function login(email: string, password: string): Promise<boolean> {
  try {
    await account.createEmailPasswordSession(email, password);
    console.log("Login successful");
    return true;
  } catch (error: any) {
    console.error("Login failed:", error.message);
    return false;
  }
}

export async function logout(): Promise<boolean> {
  try {
    await account.deleteSession("current");
    console.log("Logout successful");
    return true;
  } catch (error: any) {
    console.error("Logout failed:", error.message);
    return false;
  }
}

export async function getLoggedInUser(): Promise<any | null> {
  try {
    return await account.get();
  } catch (error: any) {
    console.error("Failed to get logged-in user:", error.message);
    return null;
  }
}
