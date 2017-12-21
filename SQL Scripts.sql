CREATE TABLE Program
(
  ProgramName VARCHAR(30) PRIMARY KEY
);

CREATE TABLE Student
(
  UserID SERIAL PRIMARY KEY,
  Email VARCHAR(20) UNIQUE,
  Username VARCHAR(20) UNIQUE,
  Password VARCHAR(16) NOT NULL,
  Level INTEGER NOT NULL check (Level <= 4),
  Program VARCHAR(30) NOT NULL REFERENCES Program(ProgramName),
  UserType CHAR(1) DEFAULT ('R') check (UserType IN ('R','M')),

  ON DELETE CASCADE
);

CREATE TABLE Resume
(
  UserID INTEGER REFERENCES Student(UserID),
  ResumeID SERIAL,
  Version SERIAL,
  Contents TEXT NOT NULL,
  ModeratorID INTEGER REFERENCES Student(UserID) DEFAULT (NULL),
  Comments TEXT DEFAULT (NULL),

  PRIMARY KEY (UserID, ResumeID, Version)
);

CREATE TABLE Company
(
  CompanyID SERIAL PRIMARY KEY,
  Cname VARCHAR(30) UNIQUE, --Name of company
  WorkEmail VARCHAR(20) UNIQUE,
  Password VARCHAR(16) NOT NULL ,
  NumberOfEmployees INTEGER NOT NULL,
  Description TEXT, --Description can be null
  TotalRating INTEGER DEFAULT (0), --Derived attribute
  NumberOfReviewwer INTEGER DEFAULT (0), --Derived attribute

  ON DELETE CASCADE
);

CREATE TABLE Job
(
  CompanyID INTEGER REFERENCES Company(CompanyID),
  Title VARCHAR(50),
  Description TEXT NOT NULL,
  TargetedProgram VARCHAR(30) NOT NULL REFERENCES Program(ProgramName),
  TargetedLevel INTEGER NOT NULL CHECK (TargetedLevel <= 4),
  NumberOfPositions INTEGER, -- optional information
  ClosingDate DATE, -- optional info
  NumberOfApplicants INTEGER DEFAULT (0),

  PRIMARY KEY (CompanyID, Title)
);

CREATE TABLE ApplyFor
(
  UserID INTEGER,
  ComID INTEGER,
  JobTitle VARCHAR(50),
  ResumeID INTEGER,
  ResumeVer INTEGER,

  PRIMARY KEY (UserID, ComID, JobTitle, ResumeID, ResumeVer),
  FOREIGN KEY (ComID, JobTitle) REFERENCES Job(companyid, Title),
  FOREIGN KEY (UserID, ResumeID, ResumeVer) REFERENCES Resume(UserID, resumeid, version)
);

CREATE TABLE Evaluation
(
  EvaluationID SERIAL PRIMARY KEY,
  /*
   *  Below are 6 aspects of evalution,
   *  each ranges from 1 to 5 points
   */
  Salary INTEGER NOT NULL,-- check (Salary BETWEEN 1 and 5),
  Guidance INTEGER NOT NULL,-- check (Guidance BETWEEN 1 and 5),
  WE INTEGER NOT NULL,-- check (WE BETWEEN 1 and 5),-- working environment
  Culture INTEGER NOT NULL,-- check (Culture BETWEEN 1 and 5),
  SandH INTEGER NOT NULL,-- check (SandH BETWEEN 1 and 5),-- Schedule and Holiday
  Colleagues INTEGER NOT NULL,-- check (Colleagues BETWEEN 1 and 5)

  check ((Salary BETWEEN 1 AND 5) AND (Guidance BETWEEN 1 AND 5) AND
             (WE BETWEEN 1 AND 5) AND (Culture BETWEEN 1 AND 5) AND
          (SandH BETWEEN 1 AND 5) AND (Colleagues BETWEEN 1 AND 5))
);

CREATE TABLE Review
(
  ReviewID SERIAL PRIMARY KEY,
  UserID INTEGER REFERENCES Student(UserID),
  CompanyID INTEGER REFERENCES Company(CompanyID),
  EvaID INTEGER REFERENCES Evaluation(EvaluationID),
  Comments TEXT NOT NULL,
  NumberOfUpvotes INTEGER DEFAULT (0) -- Derived attribute
);

CREATE TABLE upvote
(
  UserID INTEGER REFERENCES Student(UserID),
  ReviewID INTEGER REFERENCES Review(ReviewID),
  PRIMARY KEY (UserID, ReviewID)
);

-- Queries to drop all tables
DROP TABLE applyfor, company, evaluation, job, program, resume, review, student, upvote;