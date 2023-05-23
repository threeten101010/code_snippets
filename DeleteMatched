DELETE A                              --delete rows from the target table where condition below applies
FROM tableTarget A                    --Set table where rows will be matched
  WHERE EXISTS (
	SELECT A.[FundID], A.[BizCaseKey]   --select target intersection columns to check
  INTERSECT 
  SELECT B.[FundID], B.[BizCaseKey]   --select source columns to check
  FROM tableSource B                  --select source table for intersection
	)
