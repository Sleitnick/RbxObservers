"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[671],{3905:(e,t,n)=>{n.d(t,{Zo:()=>p,kt:()=>b});var r=n(67294);function a(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function o(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function l(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?o(Object(n),!0).forEach((function(t){a(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):o(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function i(e,t){if(null==e)return{};var n,r,a=function(e,t){if(null==e)return{};var n,r,a={},o=Object.keys(e);for(r=0;r<o.length;r++)n=o[r],t.indexOf(n)>=0||(a[n]=e[n]);return a}(e,t);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(r=0;r<o.length;r++)n=o[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(a[n]=e[n])}return a}var s=r.createContext({}),c=function(e){var t=r.useContext(s),n=t;return e&&(n="function"==typeof e?e(t):l(l({},t),e)),n},p=function(e){var t=c(e.components);return r.createElement(s.Provider,{value:t},e.children)},u="mdxType",d={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},g=r.forwardRef((function(e,t){var n=e.components,a=e.mdxType,o=e.originalType,s=e.parentName,p=i(e,["components","mdxType","originalType","parentName"]),u=c(n),g=a,b=u["".concat(s,".").concat(g)]||u[g]||d[g]||o;return n?r.createElement(b,l(l({ref:t},p),{},{components:n})):r.createElement(b,l({ref:t},p))}));function b(e,t){var n=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var o=n.length,l=new Array(o);l[0]=g;var i={};for(var s in t)hasOwnProperty.call(t,s)&&(i[s]=t[s]);i.originalType=e,i[u]="string"==typeof e?e:a,l[1]=i;for(var c=2;c<o;c++)l[c]=n[c];return r.createElement.apply(null,l)}return r.createElement.apply(null,n)}g.displayName="MDXCreateElement"},59881:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>s,contentTitle:()=>l,default:()=>d,frontMatter:()=>o,metadata:()=>i,toc:()=>c});var r=n(87462),a=(n(67294),n(3905));const o={sidebar_position:1},l="Getting Started",i={unversionedId:"intro",id:"intro",title:"Getting Started",description:"The Observers package can be acquired using Wally, a package manager for Roblox. Alternatively, the @rbxts/observers package is available on npm for developers using roblox-ts.",source:"@site/docs/intro.md",sourceDirName:".",slug:"/intro",permalink:"/RbxObservers/docs/intro",draft:!1,editUrl:"https://github.com/Sleitnick/RbxObservers/edit/main/docs/intro.md",tags:[],version:"current",sidebarPosition:1,frontMatter:{sidebar_position:1},sidebar:"defaultSidebar",next:{title:"Observer Pattern",permalink:"/RbxObservers/docs/observer-pattern"}},s={},c=[{value:"Wally Configuration",id:"wally-configuration",level:2},{value:"Rojo Configuration",id:"rojo-configuration",level:2},{value:"Usage Example",id:"usage-example",level:2},{value:"roblox-ts",id:"roblox-ts",level:2}],p={toc:c},u="wrapper";function d(e){let{components:t,...n}=e;return(0,a.kt)(u,(0,r.Z)({},p,n,{components:t,mdxType:"MDXLayout"}),(0,a.kt)("h1",{id:"getting-started"},"Getting Started"),(0,a.kt)("p",null,"The Observers package can be acquired using ",(0,a.kt)("a",{parentName:"p",href:"https://wally.run/"},"Wally"),", a package manager for Roblox. Alternatively, the ",(0,a.kt)("inlineCode",{parentName:"p"},"@rbxts/observers")," package is available on npm for developers using roblox-ts."),(0,a.kt)("h2",{id:"wally-configuration"},"Wally Configuration"),(0,a.kt)("p",null,"Once Wally is installed, run ",(0,a.kt)("inlineCode",{parentName:"p"},"wally init")," on your project directory, and then add the various utility modules found here as dependencies. For example, the following could be a ",(0,a.kt)("inlineCode",{parentName:"p"},"wally.toml")," file for a project that includes a few of these modules:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-toml"},'[package]\nname = "your_name/your_project"\nversion = "0.1.0"\nregistry = "https://github.com/UpliftGames/wally-index"\nrealm = "shared"\n\n[dependencies]\nObservers = "sleitnick/observers@^0.3.3"\n')),(0,a.kt)("p",null,"To install, run ",(0,a.kt)("inlineCode",{parentName:"p"},"wally install")," within your project. Wally will create a Package folder in your directory with the installed dependency."),(0,a.kt)("h2",{id:"rojo-configuration"},"Rojo Configuration"),(0,a.kt)("p",null,"The Package folder created by Wally should be synced into Roblox Studio through your Rojo configuration. For instance, a Rojo configuration might have the following entry to sync the Packages folder into ReplicatedStorage:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-json"},'{\n    "name": "rbx-util-example",\n    "tree": {\n        "$className": "DataModel",\n        "ReplicatedStorage": {\n            "$className": "ReplicatedStorage",\n            "Packages": {\n                "$path": "Packages"\n            }\n        }\n    }\n}\n')),(0,a.kt)("h2",{id:"usage-example"},"Usage Example"),(0,a.kt)("p",null,"The Observers module can now be used in scripts, such as the following:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-lua"},'local ReplicatedStorage = game:GetService("ReplicatedStorage")\n\nlocal Observers = require(ReplicatedStorage.Packages.Observers)\n\nObservers.observeTag("SomeTag", function(instance: Instance)\n    print(`Observing {instance}`)\n    return function()\n        print(`Stopped observing {instance}`)\n    end\nend)\n')),(0,a.kt)("h2",{id:"roblox-ts"},"roblox-ts"),(0,a.kt)("p",null,"For developers using roblox-ts, install the ",(0,a.kt)("inlineCode",{parentName:"p"},"@rbxts/observers")," package."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-sh"},"npm i --save @rbxts/observers\n")))}d.isMDXComponent=!0}}]);