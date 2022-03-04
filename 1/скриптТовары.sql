USE [Продажи]
GO

/****** Object:  Table [dbo].[Товары]    Script Date: 08.02.2022 17:46:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Товары](
	[Наименование] [nvarchar](20) NOT NULL,
	[Цена] [real] NULL,
	[Количество] [int] NULL,
 CONSTRAINT [PK_Товары] PRIMARY KEY CLUSTERED 
(
	[Наименование] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


