INSERT [ORNG.].[Apps] VALUES(10,'RDF Test','http://stage-profiles.ucsf.edu/apps/RDFTest.xml',NULL, 0, NULL, NULL, 0);
INSERT [ORNG.].[Apps] VALUES(101,'Featured Presentations','http://stage-profiles.ucsf.edu/apps/SlideShare.xml',NULL, 0, NULL, NULL, 1);
--INSERT [ORNG.].[Apps] VALUES(102,'Faculty Mentoring','http://stage-profiles.ucsf.edu/apps/Mentor.xml',NULL, 0, NULL, NULL, 0);
INSERT [ORNG.].[Apps] VALUES(103,'Websites','http://stage-profiles.ucsf.edu/apps/Links.xml',NULL, 0, NULL, NULL, 1);
INSERT [ORNG.].[Apps] VALUES(104,'Profile List Tool','http://stage-profiles.ucsf.edu/apps/ProfileListTool.xml',NULL, 0, NULL, NULL, 1);
INSERT [ORNG.].[Apps] VALUES(112,'Twitter','http://stage-profiles.ucsf.edu/apps/Twitter.xml',NULL, 0, NULL, NULL, 1);
INSERT [ORNG.].[Apps] VALUES(114,'Featured Videos','http://stage-profiles.ucsf.edu/apps/YouTube.xml',NULL, 0, NULL, NULL, 1);

INSERT [ORNG.].[AppViews] VALUES(10,'edit/default.aspx',NULL,'gadgets-test','Public',1, NULL);
INSERT [ORNG.].[AppViews] VALUES(10,'profile/display.aspx',NULL,'gadgets-test','Public',1, NULL);
INSERT [ORNG.].[AppViews] VALUES(104,'search/default.aspx','small','gadgets-tools','Users',1, '{''gadget_class'':''ORNGTitleBarGadget''}');
INSERT [ORNG.].[AppViews] VALUES(104,'profile/display.aspx','small','gadgets-tools','Users',1, '{''gadget_class'':''ORNGTitleBarGadget''}');
INSERT [ORNG.].[AppViews] VALUES(104,'orng/gadgetdetails.aspx','canvas','gadgets-detail','Users',1, '{''gadget_class'':''ORNGTitleBarGadget''}');

-- We have two types of gadgets
-- The most basic types are "tool gadgets".  These are controled by the AppViews table and are configured
-- The other kind is "RDF gadgets".  These are the ones that people add to their profile.  Those gadgets
-- need to be added to the ontology whenever you register them into your system.
-- not that if you set them to RegitryRequired=1, then only people who have an association with that app in the
-- [ORNG.].[AppRegistry] table will be able to add them.  This is useful for gadgets that required automated data,
-- that not everyone in your system will have


exec [ORNG.].[AddAppToOntology] 101;
--exec [ORNG.].[AddAppToOntology] 102;
exec [ORNG.].[AddAppToOntology] 103;
exec [ORNG.].[AddAppToOntology] 112;
exec [ORNG.].[AddAppToOntology] 114;
--exec [ORNG.].[AddAppToOntology] @appId = 116,@EditView = 'default', @ProfileView = 'default';

EXEC [Ontology.].[UpdateDerivedFields];

-- to remove
--exec [ORNG.].[RemoveAppFromOntology] 101;
--exec [ORNG.].[RemoveAppFromOntology] 102;
--exec [ORNG.].[RemoveAppFromOntology] 103;
--exec [ORNG.].[RemoveAppFromOntology] 112;
--exec [ORNG.].[RemoveAppFromOntology] 114;
