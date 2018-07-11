--[[
    CSIM 2018
    Lecture 10

    -- Pathfinder Library --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_pathfinder = {}

function csim_pathfinder:new(map)
    local comp = {}
    comp.map = map
    return comp
end

function csim_pathfinder:adj(node)
end

function csim_pathfinder:cost(node1, node2)
end

function csim_pathfinder:plan(source, goal)
end

function csim_pathfinder:bfs(source, goal)
    local queue = {}
	add(queue, s)

	local back_p = {}
	back_p[v_str(s)] = s

	local dist = {}
	dist[v_str(s)] = 0

	while(#queue > 0) do
		local c_node = pf_d_pop(queue, dist)

		-- if i found the goal, return the path
		if(v_str(c_node) == v_str(g)) then
			return pf_path(s,g,back_p)
		end

		-- get the list of adj nodes
		local adj_nodes = pf_adj(c_node.x, c_node.y)

		-- iterate on the list of adj nodes
		for i=1,#adj_nodes do
			local c_adj = adj_nodes[i]
			local path_cost = dist[v_str(c_node)] + pf_cost(c_node, c_adj, {4,5,6,7})

			if(dist[v_str(c_adj)] == nil or path_cost < dist[v_str(c_adj)]) then
				add(queue, c_adj)
				dist[v_str(c_adj)] = path_cost
				back_p[v_str(c_adj)] = c_node
			end
		end
	end
end

return csim_pathfinder
