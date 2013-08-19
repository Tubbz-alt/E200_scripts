function [S_ratio]= ratioteur(S_test)

S_ratio=[S_test(1,1)/S_test(1,2) S_test(1,1)./S_test(1,4) S_test(1,1)/S_test(1,5)  S_test(1,2)/S_test(1,4) S_test(1,2)./S_test(1,5)  S_test(1,4)/S_test(1,5)  ];

end