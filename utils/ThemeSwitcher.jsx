import React from "react";
import { useState, useEffect } from "react";
import { useTheme } from "next-themes";

export const ThemeSwitcher = () => {
  const [mounted, setMounted] = useState(false);
  const { theme, setTheme } = useTheme();

  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted) {
    return null;
  }
  return (
    <>
      <input
        type="checkbox"
        className="checkbox"
        id="checkbox"
        onChange={() => {
          setTheme(theme === "light" ? "dark" : "light");
        }}
      />
      <label
        htmlFor="checkbox"
        className="flexBetween w-8 h-4 bg-black rounded-2xl p-1 relative label"
      >
        <i className="fas fa-sun" />
        <i className="fas fa-moon" />
        <div className="w-3 h-3 absolute bg-white rounded-full ball" />
      </label>
    </>
  );

  // return React.createElement(
  //   "button",
  //   {
  //     className: `w-fit absolute right-5 top-2 p-2 rounded-md hover:scale-110 active:scale-100 duration-200 bg-slate-200 dark:bg-[#212933]`,
  //     onClick: () => setTheme(theme === "dark" ? "light" : "dark"),
  //   },
  //   theme === "light" ? "Dark" : "Light"
  // );
};

export default ThemeSwitcher;
