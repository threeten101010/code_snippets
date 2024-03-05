--https://www.sqlshack.com/working-with-xml-data-in-sql-server/

--generate some dummy data
CREATE DATABASE Showroom
 
Use Showroom
CREATE TABLE Car  
(  
  CarId int identity(1,1) primary key,  
  Name varchar(100),  
  Make varchar(100),  
  Model int ,  
  Price int ,  
  Type varchar(20)  
)  
    
insert into Car( Name, Make,  Model , Price, Type)
VALUES ('Corrolla','Toyota',2015, 20000,'Sedan'),
('Civic','Honda',2018, 25000,'Sedan'),
('Passo','Toyota',2012, 18000,'Hatchback'),
('Land Cruiser','Toyota',2017, 40000,'SUV'),
('Corrolla','Toyota',2011, 17000,'Sedan'),
('Vitz','Toyota',2014, 15000,'Hatchback'),
('Accord','Honda',2018, 28000,'Sedan'),
('7500','BMW',2015, 50000,'Sedan'),
('Parado','Toyota',2011, 25000,'SUV'),
('C200','Mercedez',2010, 26000,'Sedan'),
('Corrolla','Toyota',2014, 19000,'Sedan'),
('Civic','Honda',2015, 20000,'Sedan')

--The FOR XML AUTO clause converts each column in the SQL table into an attribute in the corresponding XML document
SELECT * FROM Car
FOR XML AUTO

--FOR XML PATH will create an XML document where each record is an element and each column is a nested element for a particular record
SELECT * FROM Car
FOR XML PATH

--by default, the parent element name is “row”. We can change that using the following query
SELECT * FROM Car
FOR XML PATH ('Car')

--To add a root element, we need to execute the following script:
SELECT * FROM Car
FOR XML PATH ('Car'), ROOT('Cars')

--CarId should be the attribute of the Car element rather than an element. You can do so with the following script:
SELECT  CarId as [@CarID],  
    Name  AS [CarInfo/Name],  
    Make [CarInfo/Make],  
    Model [CarInfo/Model],  
    Price,  
    Type
FROM Car 
FOR XML PATH ('Car'), ROOT('Cars')

--if we want Name, Make and Model elements to be nested inside another element CarInfo we can do so with the following script
SELECT  CarId as [@CarID],  
    Name  AS [CarInfo/Name],  
    Make [CarInfo/Make],  
    Model [CarInfo/Model],  
    Price,  
    Type
FROM Car 
FOR XML PATH ('Car'), ROOT('Cars')

--if you want to convert the elements Name and Make into an attribute of element CarInfo, you can do so with the following script
SELECT  CarId as [@CarID],  
    Name  AS [CarInfo/@Name],  
    Make [CarInfo/@Make],  
    Model [CarInfo/Model],  
    Price,  
    Type
FROM Car 
FOR XML PATH ('Car'), ROOT('Cars')

------------------------------------------------------------------------------
--to create a table with two columns that contain the values from the Name and Make attributes from the CarInfo element. We can do so using the following script
DECLARE @cars xml
 
SELECT @cars = C
FROM OPENROWSET (BULK 'D:\Cars.xml', SINGLE_BLOB) AS Cars(C)
    
SELECT @cars
    
DECLARE @hdoc int
    
EXEC sp_xml_preparedocument @hdoc OUTPUT, @cars
SELECT *
FROM OPENXML (@hdoc, '/Cars/Car/CarInfo' , 1)
WITH(
    Name VARCHAR(100),
    Make VARCHAR(100)
    )
    
    
EXEC sp_xml_removedocument @hdoc

/*
In the script above we declare an XML type variable @cars. The variable stores the result returned by the OPENROWSET function which retrieves XML data in binary format. Next using the SELECT @Cars statement we print the contents of the XML file. At this point in time, the XML document is loaded into the memory.

Next, we create a handle for the XML document. To read the attributes and elements of the XML document, we need to attach the handle with the XML document. The sp_xml_preparedocument performs this task. It takes the handle and the document variable as parameters and creates an association between them.

Next, we use the OPENXML function to read the contents of the XML document. The OPENXML function takes three parameters: the handle to the XML document, the path of the node for which we want to retrieve the attributes or elements and the mode. The mode value of 1 returns the attributes only. Next, inside the WITH clause, we need to define the name and type of the attributes that you want returned. In our case the CarInfo element has two attributes Name, and Make, therefore we retrieve both.

As a final step, we execute the sp_xml_removedocument stored procedure to remove the XML document from the memory
*/

---------------------------------------------------------------------------------------------
/*
To create a SQL table using XML elements, all you have to do is to change the mode value of the OPENXML function to 2 and change the name of the attributes to the name of the element you want to retrieve.

Suppose we want to retrieve the values for the nested CarInfo, Price and Type elements of the parent Car element, we can use the following script
*/
DECLARE @cars xml
 
SELECT @cars = C
FROM OPENROWSET (BULK 'D:\Cars.xml', SINGLE_BLOB) AS Cars(C)
    
SELECT @cars
    
DECLARE @hdoc int
    
EXEC sp_xml_preparedocument @hdoc OUTPUT, @cars
SELECT *
FROM OPENXML (@hdoc, '/Cars/Car' , 2)
WITH(
    CarInfo INT,
    Price INT,
    Type VARCHAR(100)
    )
    
    
EXEC sp_xml_removedocument @hdoc
