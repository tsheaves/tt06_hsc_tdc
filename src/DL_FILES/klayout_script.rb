prefix_str="tt_export_*"
target_cells = ['sky130_fd_sc_hd__fa_1', 'sky130_fd_sc_hd__edfxtp_1']
prune_cells = []
layout = RBA::Layout::new
layout.read($input)
layout.each_cell do |cell|
	cell_name = layout.cell_name(cell.cell_index)
	if target_cells.include? cell_name
		puts "Found " + cell_name
		new_cell_name = prefix_str.gsub(/#/, cell.cell_index.to_s).gsub(/\*/, cell_name)
		layout.rename_cell(cell.cell_index, new_cell_name)
	else
		puts "Other cell " + cell_name
		prune_cells = prune_cells + [cell_name]
	end
end
prune_cells.each do |cell|
	puts "Pruning " + cell
	layout.prune_cell(layout.cell_by_name(cell), -1)
end
layout.write($output)