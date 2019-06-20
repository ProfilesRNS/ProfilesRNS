SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Data].[Job.Log](
	LogID int IDENTITY(1,1) Primary key not null,
	Job varchar(55) not null,
	BatchID varchar(100) null,
	RowID int,
	ServiceCallStart datetime null,
	ServiceCallEnd datetime null,
	ProcessEnd datetime null,
	Success bit null,
	ErrorText varchar(max) null
)