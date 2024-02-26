--reference blog https://barneylawrence.com/2021/03/30/querying-xml-in-sql-server-part-3-handling-repeating-regions-with-the-nodes-method/

CREATE TABLE #MyXML (MyXML XML NOT NULL);
  
INSERT INTO #MyXML(MyXML)
VALUES
(
'<?xml version="1.0" encoding="UTF-8"?>
<items termsofuse="https://boardgamegeek.com/xmlapi/termsofuse">
   <item type="boardgame" id="91514">
      <thumbnail>https://cf.geekdo-images.com/R_VAhiLCzl5RXKwSluvEbg__thumb/img/zpzD1TJLfuNEjuTjpPbN1y1mpss=/fit-in/200x150/filters:strip_icc()/pic3271388.jpg</thumbnail>
      <image>https://cf.geekdo-images.com/R_VAhiLCzl5RXKwSluvEbg__original/img/hVn3HtD2_5vKNjhEBkL1qFB4FaU=/0x0/filters:format(jpeg)/pic3271388.jpg</image>
      <name type="primary" sortindex="1" value="Rhino Hero" />
      <name type="alternate" sortindex="1" value="Rino Ercolino" />
      <name type="alternate" sortindex="1" value="Super Rhino!" />
      <name type="alternate" sortindex="1" value="Super Rino!" />
      <description>
        Super Rhino! presents players with an incredibly heroic &amp;ndash; and regrettably heavy &amp;ndash; rhinoceros who is eager to climb a tall building and leap other tall buildings in a single bound. 
      </description>
      <yearpublished value="2011" />
      <minplayers value="2" />
      <maxplayers value="5" />
      <poll name="suggested_numplayers" title="User Suggested Number of Players" totalvotes="61">
         <results numplayers="1">
            <result value="Best" numvotes="0" />
            <result value="Recommended" numvotes="7" />
            <result value="Not Recommended" numvotes="29" />
         </results>
         <results numplayers="2">
            <result value="Best" numvotes="10" />
            <result value="Recommended" numvotes="40" />
            <result value="Not Recommended" numvotes="3" />
         </results>
         <results numplayers="3">
            <result value="Best" numvotes="44" />
            <result value="Recommended" numvotes="11" />
            <result value="Not Recommended" numvotes="0" />
         </results>
         <results numplayers="4">
            <result value="Best" numvotes="18" />
            <result value="Recommended" numvotes="30" />
            <result value="Not Recommended" numvotes="1" />
         </results>
         <results numplayers="5">
            <result value="Best" numvotes="5" />
            <result value="Recommended" numvotes="25" />
            <result value="Not Recommended" numvotes="13" />
         </results>
         <results numplayers="5+">
            <result value="Best" numvotes="0" />
            <result value="Recommended" numvotes="3" />
            <result value="Not Recommended" numvotes="24" />
         </results>
      </poll>
      <playingtime value="15" />
      <minplaytime value="5" />
      <maxplaytime value="15" />
      <minage value="5" />
   </item>
</items>'
);
  
SELECT * FROM #MyXML;

SELECT
R.ResultXML.query('.') AS ResultLevelXML,
R.ResultXML.value('./@numplayers','varchar(50)') AS NumPlayers,
R.ResultXML.value('(./result[@value = "Best"]/@numvotes)[1]','int') AS BestVotes,
R.ResultXML.value('(./result[@value = "Recommended"]/@numvotes)[1]','int') AS RecommendedVotes,
R.ResultXML.value('(./result[@value = "Not Recommended"]/@numvotes)[1]','int') AS NotRecommendedVotes
FROM #MyXML AS X
CROSS APPLY X.MyXML.nodes('/items/item/poll/results') AS R(ResultXML);


SELECT
R.ResultXML.query('.') AS ResultLevelXML,
R.ResultXML.value('./@numplayers','varchar(50)') AS NumPlayers,
R2.ResultsXML.value('./@value','varchar(50)') AS PollValue,
R2.ResultsXML.value('./@numvotes','int') AS NumberOfVotes
FROM #MyXML AS X
CROSS APPLY X.MyXML.nodes('/items/item/poll/results') AS R(ResultXML)
CROSS APPLY R.ResultXML.nodes('./result') AS R2(ResultsXML);


SELECT
R2.ResultsXML.query('.') AS ResultLevelXML,
R2.ResultsXML.query('..') AS ResultsLevelXML,
R2.ResultsXML.value('../@numplayers','varchar(50)') AS NumPlayers,
R2.ResultsXML.value('./@value','varchar(50)') AS PollValue,
R2.ResultsXML.value('./@numvotes','int') AS NumberOfVotes,
R2.ResultsXML.value('../../@title','varchar(50)') AS Poll
FROM #MyXML AS X
CROSS APPLY X.MyXML.nodes('/items/item/poll/results/result') AS R2(ResultsXML);
