use ASM2
go

create table Type_DIM(
	Type_Key int identity(1,1) primary key
	,Type varchar(3)
	)
go

create table Breed_DIM(
	Breed_Key int identity(1,1) primary key
	,Breed varchar(255)
	)
go

create table Gender_DIM(
	Gender_Key int identity(1,1) primary key
	,Gender varchar(6)
	)
go

create table Color_DIM(
	Color_Key int identity(1,1) primary key
	,Color varchar(255)
	)
go

create table MaturitySize_DIM(
	MaturitySize_Key int identity(1,1) primary key
	,MaturitySize varchar(13)
	)
go

create table FurLength_DIM(
	FurLength_Key int identity(1,1) primary key
	,FurLength varchar(13)
	)
go

create table Vaccinated_DIM(
	Vaccinated_Key int identity(1,1) primary key
	,Vaccinated varchar(8)
	)

create table Dewormed_DIM(
	Dewormed_Key int identity(1,1) primary key
	,Dewormed varchar(8)
	)

create table Sterilized_DIM(
	Sterilized_Key int identity(1,1) primary key
	,Sterilized varchar(8)
	)

create table Health_DIM(
	Health_Key int identity(1,1) primary key
	,Health varchar(14)
	)

create table State_DIM(
	State_Key int identity(1,1) primary key
	,State varchar(255)
	)

create table PetFinder_FACT(
	Pet_Key int identity(1,1) primary key
	,Type_Key int foreign key references Type_DIM(Type_Key)
	,Breed1_Key int foreign key references Breed_DIM(Breed_Key)
	,Breed2_Key int foreign key references Breed_DIM(Breed_Key)
	,Gender_Key int foreign key references Gender_DIM(Gender_Key)
	,Color1_Key int foreign key references Color_DIM(Color_Key)
	,Color2_Key int foreign key references Color_DIM(Color_Key)
	,Color3_Key int foreign key references Color_DIM(Color_Key)
	,MaturitySize_Key int foreign key references MaturitySize_DIM(MaturitySize_Key)
	,FurLength_Key int foreign key references FurLength_DIM(FurLength_Key)
	,Vaccinated_Key int foreign key references Vaccinated_DIM(Vaccinated_Key)
	,Dewormed_Key int foreign key references Dewormed_DIM(Dewormed_Key)
	,Sterilized_Key int foreign key references Sterilized_DIM(Sterilized_Key)
	,Health_Key int foreign key references Health_DIM(Health_Key)
	,State_Key int foreign key references State_DIM(State_Key)
	,PetID int
	,Age int
	,Quantity int
	,Fee int
	,RescuerID int
	)
go