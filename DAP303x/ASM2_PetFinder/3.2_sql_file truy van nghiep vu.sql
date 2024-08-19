use ASM2
go

-- Bang (State) nao co nhieu vat nuoi duoc tim thay nhat nhat
select
	s.State as State_Name
	,sum(p.Quantity) as Total_Quantity
from PetFinder_FACT as p
	left join State_DIM as s
		on p.State_Key = s.State_Key
group by s.State
order by Total_Quantity desc

-- Theo Loai (Type) ty le % vat nuoi da duoc Tiem phong (Vaccinated), bao nhieu vat nuoi da duoc Tay giun (Dewormed)
select
	t.Type as Pet_Type
	,sum(p.Quantity) as Total_Pet
	,sum(case when v.Vaccinated = 'Yes' then p.Quantity else 0 end) as Vaccinated_Quantity
	,cast(
		sum(case when v.Vaccinated = 'Yes' then p.Quantity else 0 end)*100.00 / sum(p.Quantity)
		as decimal(4,2)
		)
		as Vaccinated_Percent
	,sum(case when d.Dewormed = 'Yes' then p.Quantity else 0 end) as Dewormed_Quantity
	,cast(
		sum(case when d.Dewormed = 'Yes' then p.Quantity else 0 end)*100.00 / sum(p.Quantity)
		as decimal(4,2)
		)
		as Dewormed_Percent
from PetFinder_FACT p
	left join Type_DIM t on p.Type_Key = t.Type_Key
	left join Vaccinated_DIM v on p.Vaccinated_Key = v.Vaccinated_Key
	left join Dewormed_DIM d on p.Dewormed_Key = d.Dewormed_Key
group by t.Type

-- Co bao nhieu vat nuoi chua ro tinh trang Triet san (Sterilized) o moi Bang (State)
select
	se.State as State_Name
	,sum(case when sd.Sterilized = 'Not Sure' then p.Quantity else 0 end) as Unknown_Sterilized_Quantity
from PetFinder_FACT p
	left join State_DIM se on p.State_Key = se.State_Key
	left join Sterilized_DIM sd on p.Sterilized_Key = sd.Sterilized_Key
group by se.State
order by se.State

-- Co bao nhieu vat nuoi duoc tiem phong (Vaccinated) cung duoc Triet san (Sterilized)?
select
	st.State as State_Name
	,sum(case when v.Vaccinated = 'Yes' and s.Sterilized = 'Yes' then p.Quantity else 0 end) as Vaccinated_n_Sterilized
from PetFinder_FACT p
	left join State_DIM st on p.State_Key = st.State_Key
	left join Vaccinated_DIM v on p.Vaccinated_Key = v.Vaccinated_Key
	left join Sterilized_DIM s on p.Sterilized_Key = s.Sterilized_Key
/* where v.Vaccinated = 'Yes'
	and s.Sterilized = 'Yes' */
group by st.State

-- So luong vat nuoi bi Trong thuong (Serious Injury) sap xep theo Bang (State)
select
	s.State
	,sum(p.Quantity) as Serious_Injury_Quantity
from PetFinder_FACT p
	left join Health_DIM h on p.Health_Key = h.Health_Key
	left join State_DIM s on p.State_Key = s.State_Key
where h.Health = 'Serious Injury'
group by s.State
order by 2 desc

-- Top 10 Giong chinh (Breed) duoc tim thay nhieu nhat
select top 10
	b.Breed
	,sum(p.Quantity) as Quantity
from PetFinder_FACT p
	left join Breed_DIM b on p.Breed1_Key = b.Breed_Key
group by b.Breed
order by 2 desc
