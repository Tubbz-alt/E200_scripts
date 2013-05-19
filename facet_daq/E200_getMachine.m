
function state = E200_getMachine()

E200_nonBSA_list;


nonBSA = lcaGetSmart(nonBSA_list);
for i = 1:size(nonBSA_list)
	name = regexprep(nonBSA_list(i), ':', '_');
	state.(char(name)) = nonBSA(i);
end

strings = lcaGetSmart(good_strings);
for i = 1:size(good_strings)
	name = regexprep(good_strings(i), ':', '_');
	state.(char(name)) = strings(i);
end


end



