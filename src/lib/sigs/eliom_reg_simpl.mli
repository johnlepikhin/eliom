(** {2 Service registration } *)

(** The function [register service handler] will associate the
    [service] to the function [handler]. The [handler] function take
    two parameters, the GET and POST parameters of the current HTTP
    request, and should returns the corresponding page.

    The optional parameter [~scope] is {!Eliom_common.global_scope} by
    default, see the Eliom manual for detailled description {%
    <<a_manual chapter="server-services" fragment="scope"|of different
    scope>>%}.

    The optional parameter [~options] is specific to each output
    module, see the type description for more information.

    The optional parameters [?charset], [?code], [?content_type] and
    [?headers] can be used to modify the HTTP answer sent by
    Eliom. Use this with care.

    The optional parameter [~secure_session] has no effect for scope
    {!Eliom_common.global_scope}. With other scopes, the parameter is used
    to force the session service table in which the [handler] will be
    registered. By default, the service is registred in the unsecure
    session if the current request's protocol is [http], or in the
    secure session if the protocol is [https]. If set to [false]
    (resp. [true]) the [handler] will be stored in the unsecure
    (resp. secure) session. See the Eliom manual for an introduction
    to {% <<a_manual chapter="server-state"|secure state>>%}.

    The optional parameter [~error_handler] is used to specialize the
    error page when actual parameters aren't compatible with the
    expected type. The default error handler is [ fun l -> raise
    (]{!Eliom_common.Eliom_Typing_Error}[ l) ]. *)
val register :
  ?scope:[<Eliom_common.scope] ->
  ?options:options ->
  ?charset:string ->
  ?code: int ->
  ?content_type:string ->
  ?headers: Http_headers.t ->
  ?secure_session:bool ->
  service:
    ('get, 'post, _, _, _, Eliom_service.non_ext, Eliom_service.reg, _,
     _, _, return)
      Eliom_service.t ->
  ?error_handler:((string * exn) list -> page Lwt.t) ->
  ('get -> 'post -> page Lwt.t) ->
  unit
(* FIXME: secure_session is called "secure" in Eliom_state and
   Eliom_Service.unregister. *)

(** Same as {!Eliom_service.create} followed by {!register}. *)
val create :
  ?scope:[<Eliom_common.scope] ->
  ?options:options ->
  ?charset:string ->
  ?code: int ->
  ?content_type:string ->
  ?headers: Http_headers.t ->
  ?secure_session:bool ->
  ?https:bool ->
  ?name: string ->
  ?csrf_safe: bool ->
  ?csrf_scope: [<Eliom_common.user_scope] ->
  ?csrf_secure: bool ->
  ?max_use:int ->
  ?timeout:float ->
  meth:
    ('m , 'gp , 'gn , 'pp, 'pn, 'tipo, 'mf, 'gp_) Eliom_service.Meth.t ->
  id:('att, 'co, 'mf, return, 'gp_) Eliom_service.Id.t ->
  ?error_handler:((string * exn) list -> page Lwt.t) ->
  ('gp -> 'pp -> page Lwt.t) ->
  ('gp, 'pp, 'm, 'att, 'co, Eliom_service.non_ext, Eliom_service.reg, 'tipo,
   'gn, 'pn, return)
    Eliom_service.t

(** {2 Low-level function } *)

(** The function [send page] build the HTTP frame corresponding to
    [page]. This may be used for example in an service handler
    registered with {!Eliom_registration.Any.register} or when building a
    custom output module.
*)
val send :
  ?options:options ->
  ?charset:string ->
  ?code: int ->
  ?content_type:string ->
  ?headers: Http_headers.t ->
  page ->
  result Lwt.t
