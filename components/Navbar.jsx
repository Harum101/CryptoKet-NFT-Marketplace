import React, { useState, useEffect, useContext } from "react";
import { useRouter } from "next/router";
import { useTheme } from "next-themes"; //Helps to check if currently its light mode or dark mode
import Image from "next/image"; //next js optimized version of img tag
import Link from "next/link";

import images from "../assets";
import { ThemeSwitcher } from "@/utils/ThemeSwitcher";

const MenuItems = ({ isMobile, active, setActive }) => {
  const generateLink = (i) => {
    switch (i) {
      case 0:
        return "/";
      case 1:
        return "/created-nfts";
      case 2:
        return "/my-nfts";
      default:
        return "/";
    }
  };
  return (
    <ul
      className={`list-none flexCenter flex-row ${
        isMobile && "flex-col h-full"
      }`}
    >
      {["Explore NFTs", "Listed NFTs", "My NFTs"].map((item, i) => (
        <li
          key={i}
          onClick={() => {
            setActive(item);
          }}
          className={`flex flex-row items-center font-poppins font-semibold text-base dark:hover:text-white hover:text-nft-dark mx-3 ${
            active === item
              ? "dark:text-white text-nft-black-1"
              : "dark:text-nft-gray-3 text-nft-gray-2"
          }`}
        >
          <Link href={generateLink(i)}>{item}</Link>
        </li>
      ))}
    </ul>
  );
};

const Navbar = () => {
  const { theme, setTheme } = useTheme();
  const [active, setActive] = useState("Explore NFTs");
  return (
    <div>
      <nav className="flexBetween w-full fixed z-10 p-4 flex-row border-b dark:bg-nft-dark bg-white dark:border-nft-black-1 border-nft-gray-1">
        <div className="flex flex-1 flex-row justify-start">
          <Link href="/">
            <div
              className="flexCenter md:hidden cursor-pointer"
              onClick={() => {}}
            >
              <Image
                src={images.logo02}
                objectFit="contain"
                width={32}
                height={32}
                alt="logo"
              />
              <p className="dark:text-white text-nft-black-1 font-semibold text-lg ml-1">
                CryptoKet
              </p>
            </div>
          </Link>
          <Link href="/">
            <div className="hidden md:flex" onClick={() => {}}>
              <Image
                src={images.logo02}
                objectFit="contain"
                width={32}
                height={32}
                alt="logo"
              />
            </div>
          </Link>
        </div>
        <div className="flex flex-initial flex-row justify-end">
          <div className="flex items-center mr-2">
            <ThemeSwitcher />
          </div>
        </div>
        <div className="md:hidden flex">
          <ul className="list-none flexCenter flex-row">
            <MenuItems active={active} setActive={setActive} />
          </ul>
        </div>
      </nav>
    </div>
  );
};

export default Navbar;
