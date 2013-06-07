%%%---- BEGIN COPYRIGHT -------------------------------------------------------
%%%
%%% Copyright (C) 2007 - 2013, Rogvall Invest AB, <tony@rogvall.se>
%%%
%%% This software is licensed as described in the file COPYRIGHT, which
%%% you should have received as part of this distribution. The terms
%%% are also available at http://www.rogvall.se/docs/copyright.txt.
%%%
%%% You may opt to use, copy, modify, merge, publish, distribute and/or sell
%%% copies of the Software, and permit persons to whom the Software is
%%% furnished to do so, under the terms of the COPYRIGHT file.
%%%
%%% This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
%%% KIND, either express or implied.
%%%
%%%---- END COPYRIGHT ---------------------------------------------------------
%%% @author Tony Rogvall <tony@rogvall.se>
%%% @copyright (C) 2013, Tony Rogvall
%%% @doc
%%%  Gsmux supervisor
%%%
%%% Created: 7 Jun 2013  by Tony Rogvall
%%% @end

-module(gsmux_sup).

-behaviour(supervisor).

-include_lib("lager/include/log.hrl").
%% external exports
-export([start_link/0, 
	 start_link/1, 
	 stop/0]).

%% supervisor callbacks
-export([init/1]).

%%%----------------------------------------------------------------------
%%% API
%%%----------------------------------------------------------------------
start_link(Args) ->
    ?info("~p: start_link: args = ~p\n", [?MODULE, Args]),
    case supervisor:start_link({local, ?MODULE}, ?MODULE, Args) of
	{ok, Pid} ->
	    {ok, Pid, {normal, Args}};
	Error -> 
	    Error
    end.

start_link() ->
    supervisor:start_link({local,?MODULE}, ?MODULE, []).

stop() ->
    exit(normal).

%%%----------------------------------------------------------------------
%%% Callback functions from supervisor
%%%----------------------------------------------------------------------

%%----------------------------------------------------------------------
%%----------------------------------------------------------------------
init(Args) ->
    ?info("~p: init: args = ~p,\n pid = ~p\n", [?MODULE, Args, self()]),
    Gsmux = {gsmux, {gsmux, start_link, [Args]},
	     permanent, 5000, worker, [gsmux]},
    {ok,{{one_for_all,3,5}, [Gsmux]}}.
