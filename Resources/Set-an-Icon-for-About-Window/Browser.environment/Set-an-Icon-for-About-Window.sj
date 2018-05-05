@STATIC;1.0;p;15;AppController.jt;1445;@STATIC;1.0;I;23;Foundation/Foundation.jI;15;AppKit/AppKit.jt;1378;objj_executeFile("Foundation/Foundation.j", NO);objj_executeFile("AppKit/AppKit.j", NO);var GITHUB_REPO = 0;

{var the_class = objj_allocateClassPair(CPObject, "AppController"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("theWindow", "CPWindow")]);objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("applicationDidFinishLaunching:"), function $AppController__applicationDidFinishLaunching_(self, _cmd, aNotification)
{
}

,["void","CPNotification"]), new objj_method(sel_getUid("openLinkInNewTab:"), function $AppController__openLinkInNewTab_(self, _cmd, sender)
{
    console.info(sender);
    console.info((sender == null ? null : (sender.isa.method_msgSend["title"] || _objj_forward)(sender, "title")));
    switch((sender == null ? null : (sender.isa.method_msgSend["tag"] || _objj_forward)(sender, "tag"))) {
        case GITHUB_REPO:
            window.open("https://github.com/ArgosOz/Cappuccino-Cookbook-Recipes/tree/master/Set-an-Icon-for-About-Window", "_blank");
            break;
    }
}

,["void","id"]), new objj_method(sel_getUid("awakeFromCib"), function $AppController__awakeFromCib(self, _cmd)
{
    ((___r1 = self.theWindow), ___r1 == null ? null : (___r1.isa.method_msgSend["setFullPlatformWindow:"] || _objj_forward)(___r1, "setFullPlatformWindow:", YES));
    var ___r1;
}

,["void"])]);
}
p;6;main.jt;292;@STATIC;1.0;I;23;Foundation/Foundation.jI;15;AppKit/AppKit.ji;15;AppController.jt;206;objj_executeFile("Foundation/Foundation.j", NO);objj_executeFile("AppKit/AppKit.j", NO);objj_executeFile("AppController.j", YES);main = function(args, namedArgs)
{
    CPApplicationMain(args, namedArgs);
}
e;