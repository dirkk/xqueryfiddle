module namespace _ = "http://napers.lindau-nobel.org/permissions";

declare variable $_:fields-rights := map {
  "ID" := map {
    "group" := 0,
    "yr" := map {
      "view" := true(),
      "edit" := false()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := false()
    },
    "sr" := map {
      "view" := true(),
      "edit" := false()
    }
  },
  "P_NameFirst" := map {
    "group" := 1,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := true(),
      "edit" := false()
    }
  },
  "P_NameMiddle" := map {
    "group" := 1,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := true(),
      "edit" := false()
    }
  },
  "P_NameLast" := map {
    "group" := 1,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := true(),
      "edit" := false()
    }
  },
  "P_NameLastPre" := map {
    "group" := 1,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := true(),
      "edit" := false()
    }
  },
  "P_TitleAcademicPre" := map {
    "group" := 1,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := true(),
      "edit" := false()
    }
  },
  "P_TitleAcademicPost" := map {
    "group" := 1,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := true(),
      "edit" := false()
    }
  },
  "P_Gender" := map {
    "group" := 1,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := true(),
      "edit" := false()
    }
  },
  "P_DateOfBirth" := map {
    "group" := 1,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := true(),
      "edit" := false()
    }
  },
  "P_CountryOfBirth" := map {
    "group" := 1,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := true(),
      "edit" := false()
    }
  },
  "P_Nationality" := map {
    "group" := 1,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := true(),
      "edit" := false()
    }
  },
  "A2_Street" := map {
    "group" := 2,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "A2_Street2" := map {
    "group" := 2,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "A2_CompanyLocation" := map {
    "group" := 2,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "A2_City" := map {
    "group" := 2,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "A2_PostalCodePre" := map {
    "group" := 2,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "A2_PostalCodePost" := map {
    "group" := 2,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "A2_State" := map {
    "group" := 2,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "A2_Country" := map {
    "group" := 2,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "C_PhonePrivateFixed" := map {
    "group" := 2,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "C_PhonePrivateMobile" := map {
    "group" := 2,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "C_EmailPrivate" := map {
    "group" := 2,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "C_Website" := map {
    "group" := 2,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "A_Company1" := map {
    "group" := 2,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := true(),
      "edit" := false()
    }
  },
  "A_Company2" := map {
    "group" := 2,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := true(),
      "edit" := false()
    }
  },
  "A_Department" := map {
    "group" := 2,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := true(),
      "edit" := false()
    }
  },
  "A_Street" := map {
    "group" := 2,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "A_Street2" := map {
    "group" := 2,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "A_CompanyLocation" := map {
    "group" := 2,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "A_City" := map {
    "group" := 2,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := true(),
      "edit" := false()
    }
  },
  "A_PostalCodePre" := map {
    "group" := 2,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "A_PostalCodePost" := map {
    "group" := 2,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "A_State" := map {
    "group" := 2,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := true(),
      "edit" := false()
    }
  },
  "A_Country" := map {
    "group" := 2,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := true(),
      "edit" := false()
    }
  },
  "C_PhoneBusinessFixed" := map {
    "group" := 2,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "C_PhoneBusinessMobile" := map {
    "group" := 2,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "C_EmailBusiness" := map {
    "group" := 2,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "YR_Recommendation1Letter" := map {
    "group" := 3,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := true(),
      "edit" := false()
    }
  },
  "YR_Recommendation1Institution" := map {
    "group" := 3,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := true(),
      "edit" := false()
    }
  },
  "YR_Recommendation1By" := map {
    "group" := 3,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := true(),
      "edit" := false()
    }
  },
  "YR_Recommendation2Letter" := map {
    "group" := 3,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := true(),
      "edit" := false()
    }
  },
  "YR_Recommendation2Institution" := map {
    "group" := 3,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := true(),
      "edit" := false()
    }
  },
  "YR_Recommendation2By" := map {
    "group" := 3,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := true(),
      "edit" := false()
    }
  },
  "YR_Recommendation3" := map {
    "group" := 3,
    "yr" := map {
      "view" := false(),
      "edit" := false()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := true()
    },
    "sr" := map {
      "view" := true(),
      "edit" := false()
    }
  },
  "YR_Recommendation3Institution" := map {
    "group" := 3,
    "yr" := map {
      "view" := false(),
      "edit" := false()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := true()
    },
    "sr" := map {
      "view" := true(),
      "edit" := false()
    }
  },
  "YR_Recommendation3By" := map {
    "group" := 3,
    "yr" := map {
      "view" := false(),
      "edit" := false()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := true()
    },
    "sr" := map {
      "view" := true(),
      "edit" := false()
    }
  },
  "YR_Motivation" := map {
    "group" := 4,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := true(),
      "edit" := false()
    }
  },
  "YR_Remarks" := map {
    "group" := 4,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := true(),
      "edit" := false()
    }
  },
  "YR_TravelArrivalDate" := map {
    "group" := 5,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "YR_TravelArrivalTime" := map {
    "group" := 5,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "YR_TravelDepartureDate" := map {
    "group" := 5,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "YR_TravelDepartureTime" := map {
    "group" := 5,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "YR_TravelDepartureOption" := map {
    "group" := 5,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "YR_TravelGuestFamily" := map {
    "group" := 5,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "YR_TravelSpecialCondition" := map {
    "group" := 5,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "YR_TravelSpecialConditionDescription" := map {
    "group" := 5,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "YR_TravelSelfOrganizedTravel" := map {
    "group" := 5,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "YR_TravelVisaRequired" := map {
    "group" := 5,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "YR_TravelVisaAddress" := map {
    "group" := 5,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "YR_TravelPassport" := map {
    "group" := 5,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "YR_TravelPassportNumber" := map {
    "group" := 5,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "YR_TravelRemarks" := map {
    "group" := 5,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "DIR_NameFirst" := map {
    "group" := 6,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "DIR_NameLast" := map {
    "group" := 6,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "DIR_Title" := map {
    "group" := 6,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "DIR_Institution" := map {
    "group" := 6,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "DIR_InstitutionCountry" := map {
    "group" := 6,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "DIR_WorkingGroup" := map {
    "group" := 6,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "DIR_Email" := map {
    "group" := 6,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "DIR_ResearchInterests" := map {
    "group" := 6,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "DIR_ScienceMotivation" := map {
    "group" := 6,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "DIR_Fellowship" := map {
    "group" := 6,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "YR_Photo" := map {
    "group" := 6,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "DIR_LookingFor" := map {
    "group" := 6,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "DIR_InterestedInJobOffers" := map {
    "group" := 6,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "DIR_InterestedScientificJobOffers" := map {
    "group" := 6,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "DIR_InterestedJointPublications" := map {
    "group" := 6,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "DIR_InterestedInMentoring" := map {
    "group" := 6,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := true(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "YR_CheckTermsConditions" := map {
    "group" := 7,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "YR_CheckPrivacyPolicy" := map {
    "group" := 7,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "YR_CheckDirectory" := map {
    "group" := 7,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "YR_CheckDataToSupporters" := map {
    "group" := 7,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  },
  "YR_CheckSupportedByThirdParties" := map {
    "group" := 7,
    "yr" := map {
      "view" := true(),
      "edit" := true()
    },
    "ap-kp" := map {
      "view" := false(),
      "edit" := false()
    },
    "sr" := map {
      "view" := false(),
      "edit" := false()
    }
  }
};

declare variable $_:fields-nominee := (
  "P_NameFirst",
  "P_NameMiddle",
  "P_NameLast",
  "P_NameLastPre",
  "P_TitleAcademicPre",
  "P_TitleAcademicPost",
  "C_EmailPrivate"
);

declare variable $_:fields-nominee2 := (
  "YR_Recommendation1Letter",
  "YR_Recommendation1Institution",
  "YR_Recommendation1By",
  "YR_RecommendationLetter1Visible",
  "YR_Recommendation3",
  "YR_Recommendation3Institution",
  "YR_Recommendation3By",
  "YR_RecommendationLetter3Visible",
  "ID_Recommendation1Letter",
  "ID_Recommendation2Letter",
  "AP_Comment"
);
