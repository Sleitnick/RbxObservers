"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[880],{3905:(e,r,t)=>{t.d(r,{Zo:()=>l,kt:()=>d});var n=t(67294);function o(e,r,t){return r in e?Object.defineProperty(e,r,{value:t,enumerable:!0,configurable:!0,writable:!0}):e[r]=t,e}function s(e,r){var t=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);r&&(n=n.filter((function(r){return Object.getOwnPropertyDescriptor(e,r).enumerable}))),t.push.apply(t,n)}return t}function a(e){for(var r=1;r<arguments.length;r++){var t=null!=arguments[r]?arguments[r]:{};r%2?s(Object(t),!0).forEach((function(r){o(e,r,t[r])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(t)):s(Object(t)).forEach((function(r){Object.defineProperty(e,r,Object.getOwnPropertyDescriptor(t,r))}))}return e}function i(e,r){if(null==e)return{};var t,n,o=function(e,r){if(null==e)return{};var t,n,o={},s=Object.keys(e);for(n=0;n<s.length;n++)t=s[n],r.indexOf(t)>=0||(o[t]=e[t]);return o}(e,r);if(Object.getOwnPropertySymbols){var s=Object.getOwnPropertySymbols(e);for(n=0;n<s.length;n++)t=s[n],r.indexOf(t)>=0||Object.prototype.propertyIsEnumerable.call(e,t)&&(o[t]=e[t])}return o}var p=n.createContext({}),c=function(e){var r=n.useContext(p),t=r;return e&&(t="function"==typeof e?e(r):a(a({},r),e)),t},l=function(e){var r=c(e.components);return n.createElement(p.Provider,{value:r},e.children)},u="mdxType",b={inlineCode:"code",wrapper:function(e){var r=e.children;return n.createElement(n.Fragment,{},r)}},f=n.forwardRef((function(e,r){var t=e.components,o=e.mdxType,s=e.originalType,p=e.parentName,l=i(e,["components","mdxType","originalType","parentName"]),u=c(t),f=o,d=u["".concat(p,".").concat(f)]||u[f]||b[f]||s;return t?n.createElement(d,a(a({ref:r},l),{},{components:t})):n.createElement(d,a({ref:r},l))}));function d(e,r){var t=arguments,o=r&&r.mdxType;if("string"==typeof e||o){var s=t.length,a=new Array(s);a[0]=f;var i={};for(var p in r)hasOwnProperty.call(r,p)&&(i[p]=r[p]);i.originalType=e,i[u]="string"==typeof e?e:o,a[1]=i;for(var c=2;c<s;c++)a[c]=t[c];return n.createElement.apply(null,a)}return n.createElement.apply(null,t)}f.displayName="MDXCreateElement"},58055:(e,r,t)=>{t.r(r),t.d(r,{assets:()=>p,contentTitle:()=>a,default:()=>b,frontMatter:()=>s,metadata:()=>i,toc:()=>c});var n=t(87462),o=(t(67294),t(3905));const s={},a="Properties",i={unversionedId:"Observers/properties",id:"Observers/properties",title:"Properties",description:"Observing properties on instances can be done via the observeProperty observer.",source:"@site/docs/Observers/properties.md",sourceDirName:"Observers",slug:"/Observers/properties",permalink:"/RbxObservers/docs/Observers/properties",draft:!1,editUrl:"https://github.com/Sleitnick/RbxObservers/edit/main/docs/Observers/properties.md",tags:[],version:"current",frontMatter:{},sidebar:"defaultSidebar",previous:{title:"Players",permalink:"/RbxObservers/docs/Observers/players"},next:{title:"Tags",permalink:"/RbxObservers/docs/Observers/tags"}},p={},c=[],l={toc:c},u="wrapper";function b(e){let{components:r,...t}=e;return(0,o.kt)(u,(0,n.Z)({},l,t,{components:r,mdxType:"MDXLayout"}),(0,o.kt)("h1",{id:"properties"},"Properties"),(0,o.kt)("p",null,"Observing properties on instances can be done via the ",(0,o.kt)("inlineCode",{parentName:"p"},"observeProperty")," observer."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},'Observers.observeProperty(workspace.Model, "Name", function(name)\n    print("Name is now: " .. name)\n\n    return function()\n        print("Name is no longer: " .. name)\n    end\nend)\n')))}b.isMDXComponent=!0}}]);