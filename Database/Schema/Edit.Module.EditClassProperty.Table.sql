SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Edit.Module].[EditClassProperty](
	[Class] [varchar](400) NOT NULL,
	[Property] [varchar](400) NOT NULL,
	[AddUpdateStoredProcedure] [varchar](max) NOT NULL,
	[GetDataStoredProcedure] [varchar](max) NOT NULL,
	[EditModule][varchar](100) NULL,
	[_ClassNode] [bigint] not NULL,
	[_PropertyNode] [bigint] not NULL,
PRIMARY KEY CLUSTERED 
(
	[_ClassNode],[_PropertyNode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
