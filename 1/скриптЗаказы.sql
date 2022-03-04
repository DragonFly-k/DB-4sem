USE [Продажи]
GO

/****** Object:  Table [dbo].[Заказы]    Script Date: 08.02.2022 17:46:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Заказы](
	[Номер_заказа] [nvarchar](10) NOT NULL,
	[Наименование_товара] [nvarchar](20) NULL,
	[Цена_продажи] [real] NULL,
	[Количество] [int] NULL,
	[Дата_поставки] [date] NULL,
	[Заказчик] [nvarchar](20) NULL,
 CONSTRAINT [PK_Заказы] PRIMARY KEY CLUSTERED 
(
	[Номер_заказа] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Заказы]  WITH CHECK ADD  CONSTRAINT [FK_Заказы_Заказчики] FOREIGN KEY([Заказчик])
REFERENCES [dbo].[Заказчики] ([Наименование_фирмы])
GO

ALTER TABLE [dbo].[Заказы] CHECK CONSTRAINT [FK_Заказы_Заказчики]
GO

ALTER TABLE [dbo].[Заказы]  WITH CHECK ADD  CONSTRAINT [FK_Заказы_Товары] FOREIGN KEY([Наименование_товара])
REFERENCES [dbo].[Товары] ([Наименование])
GO

ALTER TABLE [dbo].[Заказы] CHECK CONSTRAINT [FK_Заказы_Товары]
GO


