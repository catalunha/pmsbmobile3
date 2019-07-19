- p1
  - q1
  - family: A
  - familyPrevious: 
  - familyNext: B
  - familyReq: 
  - reqId: a1
  - reqParent:


- p2
  - q1
  - family: B
  - familyPrevious: 
  - familyNext: C
  - familyReq: A
  - reqId: b1
  - reqParent: a1



- p3
  - q2
  - family: C
  - familyPrevious: 
  - familyNext: D
  - familyReq: B
  - reqId: c1
  - reqParent: b1 || b2 (escolho req pai)



- p4
  - q2
  - family: D
  - familyPrevious: 
  - familyNext: E
  - familyReq: A
  - reqId: d1
  - reqParent: a1 || a2