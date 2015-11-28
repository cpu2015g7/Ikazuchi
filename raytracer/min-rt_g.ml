(* open MiniMLRuntime;; *)

(**************** ¥°¥í¡¼¥Ğ¥ëÊÑ¿ô¤ÎÀë¸À ****************)

(* ¥ª¥Ö¥¸¥§¥¯¥È¤Î¸Ä¿ô *)
let n_objects = create_array 1 0 in

(* ¥ª¥Ö¥¸¥§¥¯¥È¤Î¥Ç¡¼¥¿¤òÆş¤ì¤ë¥Ù¥¯¥È¥ë¡ÊºÇÂç60¸Ä¡Ë*)
let objects =
  let dummy = create_array 0 0.0 in
  create_array 60 (0, 0, 0, 0, dummy, dummy, false, dummy, dummy, dummy, dummy) in

(* Screen ¤ÎÃæ¿´ºÂÉ¸ *)
let screen = create_array 3 0.0 in
(* »ëÅÀ¤ÎºÂÉ¸ *)
let viewpoint = create_array 3 0.0 in
(* ¸÷¸»Êı¸ş¥Ù¥¯¥È¥ë (Ã±°Ì¥Ù¥¯¥È¥ë) *)
let light = create_array 3 0.0 in
(* ¶ÀÌÌ¥Ï¥¤¥é¥¤¥È¶¯ÅÙ (É¸½à=255) *)
let beam = create_array 1 255.0 in
(* AND ¥Í¥Ã¥È¥ï¡¼¥¯¤òÊİ»ı *)
let and_net = create_array 50 (create_array 1 (-1)) in
(* OR ¥Í¥Ã¥È¥ï¡¼¥¯¤òÊİ»ı *)
let or_net = create_array 1 (create_array 1 (and_net.(0))) in

(* °Ê²¼¡¢¸òº¹È½Äê¥ë¡¼¥Á¥ó¤ÎÊÖ¤êÃÍ³ÊÇ¼ÍÑ *)
(* solver ¤Î¸òÅÀ ¤Î t ¤ÎÃÍ *)
let solver_dist = create_array 1 0.0 in
(* ¸òÅÀ¤ÎÄ¾ÊıÂÎÉ½ÌÌ¤Ç¤ÎÊı¸ş *)
let intsec_rectside = create_array 1 0 in
(* È¯¸«¤·¤¿¸òÅÀ¤ÎºÇ¾®¤Î t *)
let tmin = create_array 1 (1000000000.0) in
(* ¸òÅÀ¤ÎºÂÉ¸ *)
let intersection_point = create_array 3 0.0 in
(* ¾×ÆÍ¤·¤¿¥ª¥Ö¥¸¥§¥¯¥ÈÈÖ¹æ *)
let intersected_object_id = create_array 1 0 in
(* Ë¡Àş¥Ù¥¯¥È¥ë *)
let nvector = create_array 3 0.0 in
(* ¸òÅÀ¤Î¿§ *)
let texture_color = create_array 3 0.0 in

(* ·×»»Ãæ¤Î´ÖÀÜ¼õ¸÷¶¯ÅÙ¤òÊİ»ı *)
let diffuse_ray = create_array 3 0.0 in
(* ¥¹¥¯¥ê¡¼¥ó¾å¤ÎÅÀ¤ÎÌÀ¤ë¤µ *)
let rgb = create_array 3 0.0 in

(* ²èÁü¥µ¥¤¥º *)
let image_size = create_array 2 0 in
(* ²èÁü¤ÎÃæ¿´ = ²èÁü¥µ¥¤¥º¤ÎÈ¾Ê¬ *)
let image_center = create_array 2 0 in
(* 3¼¡¸µ¾å¤Î¥Ô¥¯¥»¥ë´Ö³Ö *)
let scan_pitch = create_array 1 0.0 in

(* judge_intersection¤ËÍ¿¤¨¤ë¸÷Àş»ÏÅÀ *)
let startp = create_array 3 0.0 in
(* judge_intersection_fast¤ËÍ¿¤¨¤ë¸÷Àş»ÏÅÀ *)
let startp_fast = create_array 3 0.0 in

(* ²èÌÌ¾å¤Îx,y,z¼´¤Î3¼¡¸µ¶õ´Ö¾å¤ÎÊı¸ş *)
let screenx_dir = create_array 3 0.0 in
let screeny_dir = create_array 3 0.0 in
let screenz_dir = create_array 3 0.0 in

(* Ä¾ÀÜ¸÷ÄÉÀ×¤Ç»È¤¦¸÷Êı¸ş¥Ù¥¯¥È¥ë *)
let ptrace_dirvec  = create_array 3 0.0 in

(* ´ÖÀÜ¸÷¥µ¥ó¥×¥ê¥ó¥°¤Ë»È¤¦Êı¸ş¥Ù¥¯¥È¥ë *)
let dirvecs =
  let dummyf = create_array 0 0.0 in
  let dummyff = create_array 0 dummyf in
  let dummy_vs = create_array 0 (dummyf, dummyff) in
  create_array 5 dummy_vs in

(* ¸÷¸»¸÷¤ÎÁ°½èÍıºÑ¤ßÊı¸ş¥Ù¥¯¥È¥ë *)
let light_dirvec =
  let dummyf2 = create_array 0 0.0 in
  let v3 = create_array 3 0.0 in
  let consts = create_array 60 dummyf2 in
  (v3, consts) in

(* ¶ÀÊ¿ÌÌ¤ÎÈ¿¼Í¾ğÊó *)
let reflections =
  let dummyf3 = create_array 0 0.0 in
  let dummyff3 = create_array 0 dummyf3 in
  let dummydv = (dummyf3, dummyff3) in
  create_array 180 (0, dummydv, 0.0) in

(* reflections¤ÎÍ­¸ú¤ÊÍ×ÁÇ¿ô *)

let n_reflections = create_array 1 0 in
(* (*NOMINCAML open MiniMLRuntime;;*)
(*NOMINCAML open Globals;;*)
(*MINCAML*) let true = 1 in
(*MINCAML*) let false = 0 in *)
(*MINCAML*) let rec xor x y = if x then not y else y in

(******************************************************************************
   ƒ†[ƒeƒBƒŠƒeƒB[
 *****************************************************************************)

(* •„† *)
let rec sgn x =
  if fiszero x then 0.0
  else if fispos x then 1.0
  else -1.0
in

(* ğŒ•t‚«•„†”½“] *)
let rec fneg_cond cond x =
  if cond then x else fneg x
in

(* (x+y) mod 5 *)
let rec add_mod5 x y =
  let sum = x + y in
  if sum >= 5 then sum - 5 else sum
in

(******************************************************************************
   ƒxƒNƒgƒ‹‘€ì‚Ì‚½‚ß‚ÌƒvƒŠƒ~ƒeƒBƒu
 *****************************************************************************)

(*
let rec vecprint v =
  (o_param_abc m) inFormat.eprintf "(%f %f %f)" v.(0) v.(1) v.(2)
in
*)

(* ’l‘ã“ü *)
let rec vecset v x y z =
  v.(0) <- x;
  v.(1) <- y;
  v.(2) <- z
in

(* “¯‚¶’l‚Å–„‚ß‚é *)
let rec vecfill v elem =
  v.(0) <- elem;
  v.(1) <- elem;
  v.(2) <- elem
in

(* —ë‰Šú‰» *)
let rec vecbzero v =
  vecfill v 0.0
in

(* ƒRƒs[ *)
let rec veccpy dest src =
  dest.(0) <- src.(0);
  dest.(1) <- src.(1);
  dest.(2) <- src.(2)
in

(* ‹——£‚Ì©æ *)
let rec vecdist2 p q =
  fsqr (p.(0) -. q.(0)) +. fsqr (p.(1) -. q.(1)) +. fsqr (p.(2) -. q.(2))
in

(* ³‹K‰» ƒ[ƒŠ„‚èƒ`ƒFƒbƒN–³‚µ *)
let rec vecunit v =
  let il = 1.0 /. sqrt(fsqr v.(0) +. fsqr v.(1) +. fsqr v.(2)) in
  v.(0) <- v.(0) *. il;
  v.(1) <- v.(1) *. il;
  v.(2) <- v.(2) *. il
in

(* •„†•t³‹K‰» ƒ[ƒŠ„ƒ`ƒFƒbƒN*)
let rec vecunit_sgn v inv =
  let l = sqrt (fsqr v.(0) +. fsqr v.(1) +. fsqr v.(2)) in
  let il = if fiszero l then 1.0 else if inv then -1.0 /. l else 1.0 /. l in
  v.(0) <- v.(0) *. il;
  v.(1) <- v.(1) *. il;
  v.(2) <- v.(2) *. il
in

(* “àÏ *)
let rec veciprod v w =
  v.(0) *. w.(0) +. v.(1) *. w.(1) +. v.(2) *. w.(2)
in

(* “àÏ ˆø”Œ`®‚ªˆÙ‚È‚é”Å *)
let rec veciprod2 v w0 w1 w2 =
  v.(0) *. w0 +. v.(1) *. w1 +. v.(2) *. w2
in

(* •Ê‚ÈƒxƒNƒgƒ‹‚Ì’è””{‚ğ‰ÁZ *)
let rec vecaccum dest scale v =
  dest.(0) <- dest.(0) +. scale *. v.(0);
  dest.(1) <- dest.(1) +. scale *. v.(1);
  dest.(2) <- dest.(2) +. scale *. v.(2)
in

(* ƒxƒNƒgƒ‹‚Ì˜a *)
let rec vecadd dest v =
  dest.(0) <- dest.(0) +. v.(0);
  dest.(1) <- dest.(1) +. v.(1);
  dest.(2) <- dest.(2) +. v.(2)
in

(* ƒxƒNƒgƒ‹—v‘f“¯m‚ÌÏ *)
let rec vecmul dest v =
  dest.(0) <- dest.(0) *. v.(0);
  dest.(1) <- dest.(1) *. v.(1);
  dest.(2) <- dest.(2) *. v.(2)
in

(* ƒxƒNƒgƒ‹‚ğ’è””{ *)
let rec vecscale dest scale =
  dest.(0) <- dest.(0) *. scale;
  dest.(1) <- dest.(1) *. scale;
  dest.(2) <- dest.(2) *. scale
in

(* ‘¼‚Ì‚QƒxƒNƒgƒ‹‚Ì—v‘f“¯m‚ÌÏ‚ğŒvZ‚µ‰ÁZ *)
let rec vecaccumv dest v w =
  dest.(0) <- dest.(0) +. v.(0) *. w.(0);
  dest.(1) <- dest.(1) +. v.(1) *. w.(1);
  dest.(2) <- dest.(2) +. v.(2) *. w.(2)
in

(******************************************************************************
   ƒIƒuƒWƒFƒNƒgƒf[ƒ^\‘¢‚Ö‚ÌƒAƒNƒZƒXŠÖ”
 *****************************************************************************)

(* ƒeƒNƒXƒ`ƒƒí 0:–³‚µ 1:s¼–Í—l 2:È–Í—l 3:“¯S‰~–Í—l 4:”Á“_*)
let rec o_texturetype m =
  let (m_tex, xm_shape, xm_surface, xm_isrot,
       xm_abc, xm_xyz,
       xm_invert, xm_surfparams, xm_color,
       xm_rot123, xm_ctbl) = m
  in
  m_tex
in

(* •¨‘Ì‚ÌŒ`ó 0:’¼•û‘Ì 1:•½–Ê 2:“ñŸ‹È–Ê 3:‰~ *)
let rec o_form m =
  let (xm_tex, m_shape, xm_surface, xm_isrot,
       xm_abc, xm_xyz,
       xm_invert, xm_surfparams, xm_color,
       xm_rot123, xm_ctbl) = m
  in
  m_shape
in

(* ”½Ë“Á« 0:ŠgU”½Ë‚Ì‚İ 1:ŠgU{”ñŠ®‘S‹¾–Ê”½Ë 2:ŠgU{Š®‘S‹¾–Ê”½Ë *)
let rec o_reflectiontype m =
  let (xm_tex, xm_shape, m_surface, xm_isrot,
       xm_abc, xm_xyz,
       xm_invert, xm_surfparams, xm_color,
       xm_rot123, xm_ctbl) = m
  in
  m_surface
in

(* ‹È–Ê‚ÌŠO‘¤‚ª^‚©‚Ç‚¤‚©‚Ìƒtƒ‰ƒO true:ŠO‘¤‚ª^ false:“à‘¤‚ª^ *)
let rec o_isinvert m =
  let (xm_tex, xm_shape, xm_surface, xm_isrot,
       xm_abc, xm_xyz,
       m_invert, xm_surfparams, xm_color,
       xm_rot123, xm_ctbl) = m in
  m_invert
in

(* ‰ñ“]‚Ì—L–³ true:‰ñ“]‚ ‚è false:‰ñ“]–³‚µ 2Ÿ‹È–Ê‚Æ‰~‚Ì‚İ—LŒø *)
let rec o_isrot m =
  let (xm_tex, xm_shape, xm_surface, m_isrot,
       xm_abc, xm_xyz,
       xm_invert, xm_surfparams, xm_color,
       xm_rot123, xm_ctbl) = m in
  m_isrot
in

(* •¨‘ÌŒ`ó‚Ì aƒpƒ‰ƒ[ƒ^ *)
let rec o_param_a m =
  let (xm_tex, xm_shape, xm_surface, xm_isrot,
       m_abc, xm_xyz,
       xm_invert, xm_surfparams, xm_color,
       xm_rot123, xm_ctbl) = m
  in
  m_abc.(0)
in

(* •¨‘ÌŒ`ó‚Ì bƒpƒ‰ƒ[ƒ^ *)
let rec o_param_b m =
  let (xm_tex, xm_shape, xm_surface, xm_isrot,
       m_abc, xm_xyz,
       xm_invert, xm_surfparams, xm_color,
       xm_rot123, xm_ctbl) = m
  in
  m_abc.(1)
in

(* •¨‘ÌŒ`ó‚Ì cƒpƒ‰ƒ[ƒ^ *)
let rec o_param_c m =
  let (xm_tex, xm_shape, xm_surface, xm_isrot,
       m_abc, xm_xyz,
       xm_invert, xm_surfparams, xm_color,
       xm_rot123, xm_ctbl) = m
  in
  m_abc.(2)
in

(* •¨‘ÌŒ`ó‚Ì abcƒpƒ‰ƒ[ƒ^ *)
let rec o_param_abc m =
  let (xm_tex, xm_shape, xm_surface, xm_isrot,
       m_abc, xm_xyz,
       xm_invert, xm_surfparams, xm_color,
       xm_rot123, xm_ctbl) = m
  in
  m_abc
in

(* •¨‘Ì‚Ì’†SxÀ•W *)
let rec o_param_x m =
  let (xm_tex, xm_shape, xm_surface, xm_isrot,
       xm_abc, m_xyz,
       xm_invert, xm_surfparams, xm_color,
       xm_rot123, xm_ctbl) = m
  in
  m_xyz.(0)
in

(* •¨‘Ì‚Ì’†SyÀ•W *)
let rec o_param_y m =
  let (xm_tex, xm_shape, xm_surface, xm_isrot,
       xm_abc, m_xyz,
       xm_invert, xm_surfparams, xm_color,
       xm_rot123, xm_ctbl) = m
  in
  m_xyz.(1)
in

(* •¨‘Ì‚Ì’†SzÀ•W *)
let rec o_param_z m =
  let (xm_tex, xm_shape, xm_surface, xm_isrot,
       xm_abc, m_xyz,
       xm_invert, xm_surfparams, xm_color,
       xm_rot123, xm_ctbl) = m
  in
  m_xyz.(2)
in

(* •¨‘Ì‚ÌŠgU”½Ë—¦ 0.0 -- 1.0 *)
let rec o_diffuse m =
  let (xm_tex, xm_shape, xm_surface, xm_isrot,
       xm_abc, xm_xyz,
       xm_invert, m_surfparams, xm_color,
       xm_rot123, xm_ctbl) = m
  in
  m_surfparams.(0)
in

(* •¨‘Ì‚Ì•sŠ®‘S‹¾–Ê”½Ë—¦ 0.0 -- 1.0 *)
let rec o_hilight m =
  let (xm_tex, xm_shape, xm_surface, xm_isrot,
       xm_abc, xm_xyz,
       xm_invert, m_surfparams, xm_color,
       xm_rot123, xm_ctbl) = m
  in
  m_surfparams.(1)
in

(* •¨‘ÌF‚Ì R¬•ª *)
let rec o_color_red m =
  let (xm_tex, xm_shape, m_surface, xm_isrot,
       xm_abc, xm_xyz,
       xm_invert, xm_surfparams, m_color,
       xm_rot123, xm_ctbl) = m
  in
  m_color.(0)
in

(* •¨‘ÌF‚Ì G¬•ª *)
let rec o_color_green m =
  let (xm_tex, xm_shape, m_surface, xm_isrot,
       xm_abc, xm_xyz,
       xm_invert, xm_surfparams, m_color,
       xm_rot123, xm_ctbl) = m
  in
  m_color.(1)
in

(* •¨‘ÌF‚Ì B¬•ª *)
let rec o_color_blue m =
  let (xm_tex, xm_shape, m_surface, xm_isrot,
       xm_abc, xm_xyz,
       xm_invert, xm_surfparams, m_color,
       xm_rot123, xm_ctbl) = m
  in
  m_color.(2)
in

(* •¨‘Ì‚Ì‹È–Ê•û’ö®‚Ì y*z€‚ÌŒW” 2Ÿ‹È–Ê‚Æ‰~‚ÅA‰ñ“]‚ª‚ ‚éê‡‚Ì‚İ *)
let rec o_param_r1 m =
  let (xm_tex, xm_shape, xm_surface, xm_isrot,
       xm_abc, xm_xyz,
       xm_invert, xm_surfparams, xm_color,
       m_rot123, xm_ctbl) = m
  in
  m_rot123.(0)
in

(* •¨‘Ì‚Ì‹È–Ê•û’ö®‚Ì x*z€‚ÌŒW” 2Ÿ‹È–Ê‚Æ‰~‚ÅA‰ñ“]‚ª‚ ‚éê‡‚Ì‚İ *)
let rec o_param_r2 m =
  let (xm_tex, xm_shape, xm_surface, xm_isrot,
       xm_abc, xm_xyz,
       xm_invert, xm_surfparams, xm_color,
       m_rot123, xm_ctbl) = m
  in
  m_rot123.(1)
in

(* •¨‘Ì‚Ì‹È–Ê•û’ö®‚Ì x*y€‚ÌŒW” 2Ÿ‹È–Ê‚Æ‰~‚ÅA‰ñ“]‚ª‚ ‚éê‡‚Ì‚İ *)
let rec o_param_r3 m =
  let (xm_tex, xm_shape, xm_surface, xm_isrot,
       xm_abc, xm_xyz,
       xm_invert, xm_surfparams, xm_color,
       m_rot123, xm_ctbl) = m
  in
  m_rot123.(2)
in

(* Œõü‚Ì”­Ë“_‚ğ‚ ‚ç‚©‚¶‚ßŒvZ‚µ‚½ê‡‚Ì’è”ƒe[ƒuƒ‹ *)
(*
   0 -- 2 ”Ô–Ú‚Ì—v‘f: •¨‘Ì‚ÌŒÅ—LÀ•WŒn‚É•½sˆÚ“®‚µ‚½Œõün“_
   3”Ô–Ú‚Ì—v‘f:
   ’¼•û‘Ì¨–³Œø
   •½–Ê¨ abcƒxƒNƒgƒ‹‚Æ‚Ì“àÏ
   “ñŸ‹È–ÊA‰~¨“ñŸ•û’ö®‚Ì’è”€
 *)
let rec o_param_ctbl m =
  let (xm_tex, xm_shape, xm_surface, xm_isrot,
       xm_abc, xm_xyz,
       xm_invert, xm_surfparams, xm_color,
       xm_rot123, m_ctbl) = m
  in
  m_ctbl
in

(******************************************************************************
   Pixelƒf[ƒ^‚Ìƒƒ“ƒoƒAƒNƒZƒXŠÖ”ŒQ
 *****************************************************************************)

(* ’¼ÚŒõ’ÇÕ‚Å“¾‚ç‚ê‚½ƒsƒNƒZƒ‹‚ÌRGB’l *)
let rec p_rgb pixel =
  let (m_rgb, xm_isect_ps, xm_sids, xm_cdif, xm_engy,
       xm_r20p, xm_gid, xm_nvectors ) = pixel in
  m_rgb
in

(* ”ò‚Î‚µ‚½Œõ‚ª•¨‘Ì‚ÆÕ“Ë‚µ‚½“_‚Ì”z—ñ *)
let rec p_intersection_points pixel =
  let (xm_rgb, m_isect_ps, xm_sids, xm_cdif, xm_engy,
       xm_r20p, xm_gid, xm_nvectors ) = pixel in
  m_isect_ps
in

(* ”ò‚Î‚µ‚½Œõ‚ªÕ“Ë‚µ‚½•¨‘Ì–Ê”Ô†‚Ì”z—ñ *)
(* •¨‘Ì–Ê”Ô†‚Í ƒIƒuƒWƒFƒNƒg”Ô† * 4 + (solver‚Ì•Ô‚è’l) *)
let rec p_surface_ids pixel =
  let (xm_rgb, xm_isect_ps, m_sids, xm_cdif, xm_engy,
       xm_r20p, xm_gid, xm_nvectors ) = pixel in
  m_sids
in

(* ŠÔÚóŒõ‚ğŒvZ‚·‚é‚©”Û‚©‚Ìƒtƒ‰ƒO *)
let rec p_calc_diffuse pixel =
  let (xm_rgb, xm_isect_ps, xm_sids, m_cdif, xm_engy,
       xm_r20p, xm_gid, xm_nvectors ) = pixel in
  m_cdif
in

(* Õ“Ë“_‚ÌŠÔÚóŒõƒGƒlƒ‹ƒM[‚ªƒsƒNƒZƒ‹‹P“x‚É—^‚¦‚éŠñ—^‚Ì‘å‚«‚³ *)
let rec p_energy pixel =
  let (xm_rgb, xm_isect_ps, xm_sids, xm_cdif, m_engy,
       xm_r20p, xm_gid, xm_nvectors ) = pixel in
  m_engy
in

(* Õ“Ë“_‚ÌŠÔÚóŒõƒGƒlƒ‹ƒM[‚ğŒõü–{”‚ğ1/5‚ÉŠÔˆø‚«‚µ‚ÄŒvZ‚µ‚½’l *)
let rec p_received_ray_20percent pixel =
  let (xm_rgb, xm_isect_ps, xm_sids, xm_cdif, xm_engy,
       m_r20p, xm_gid, xm_nvectors ) = pixel in
  m_r20p
in

(* ‚±‚ÌƒsƒNƒZƒ‹‚ÌƒOƒ‹[ƒv ID *)
(*
   ƒXƒNƒŠ[ƒ“À•W (x,y)‚Ì“_‚ÌƒOƒ‹[ƒvID‚ğ (x+2*y) mod 5 ‚Æ’è‚ß‚é
   Œ‹‰ÊA‰º}‚Ì‚æ‚¤‚È•ª‚¯•û‚É‚È‚èAŠe“_‚Íã‰º¶‰E4“_‚Æ•Ê‚ÈƒOƒ‹[ƒv‚É‚È‚é
   0 1 2 3 4 0 1 2 3 4
   2 3 4 0 1 2 3 4 0 1
   4 0 1 2 3 4 0 1 2 3
   1 2 3 4 0 1 2 3 4 0
*)

let rec p_group_id pixel =
  let (xm_rgb, xm_isect_ps, xm_sids, xm_cdif, xm_engy,
       xm_r20p, m_gid, xm_nvectors ) = pixel in
  m_gid.(0)
in

(* ƒOƒ‹[ƒvID‚ğƒZƒbƒg‚·‚éƒAƒNƒZƒXŠÖ” *)
let rec p_set_group_id pixel id =
  let (xm_rgb, xm_isect_ps, xm_sids, xm_cdif, xm_engy,
       xm_r20p, m_gid, xm_nvectors ) = pixel in
  m_gid.(0) <- id
in

(* ŠeÕ“Ë“_‚É‚¨‚¯‚é–@üƒxƒNƒgƒ‹ *)
let rec p_nvectors pixel =
  let (xm_rgb, xm_isect_ps, xm_sids, xm_cdif, xm_engy,
       xm_r20p, xm_gid, m_nvectors ) = pixel in
  m_nvectors
in

(******************************************************************************
   ‘Oˆ—Ï‚İ•ûŒüƒxƒNƒgƒ‹‚Ìƒƒ“ƒoƒAƒNƒZƒXŠÖ”
 *****************************************************************************)

(* ƒxƒNƒgƒ‹ *)
let rec d_vec d =
  let (m_vec, xm_const) = d in
  m_vec
in

(* ŠeƒIƒuƒWƒFƒNƒg‚É‘Î‚µ‚Äì‚Á‚½ solver ‚‘¬‰»—p’è”ƒe[ƒuƒ‹ *)
let rec d_const d =
  let (dm_vec, m_const) = d in
  m_const
in

(******************************************************************************
   •½–Ê‹¾–Ê‘Ì‚Ì”½Ëî•ñ
 *****************************************************************************)

(* –Ê”Ô† ƒIƒuƒWƒFƒNƒg”Ô†*4 + (solver‚Ì•Ô‚è’l) *)
let rec r_surface_id r =
  let (m_sid, xm_dvec, xm_br) = r in
  m_sid
in

(* ŒõŒ¹Œõ‚Ì”½Ë•ûŒüƒxƒNƒgƒ‹(Œõ‚Æ‹tŒü‚«) *)
let rec r_dvec r =
  let (xm_sid, m_dvec, xm_br) = r in
  m_dvec
in

(* •¨‘Ì‚Ì”½Ë—¦ *)
let rec r_bright r =
  let (xm_sid, xm_dvec, m_br) = r in
  m_br
in

(******************************************************************************
   ƒf[ƒ^“Ç‚İ‚İ‚ÌŠÖ”ŒQ
 *****************************************************************************)

(* ƒ‰ƒWƒAƒ“ *)
let rec rad x =
  x *. 0.017453293
in

(**** ŠÂ‹«ƒf[ƒ^‚Ì“Ç‚İ‚İ ****)
let rec read_screen_settings _ =

  (* ƒXƒNƒŠ[ƒ“’†S‚ÌÀ•W *)
  screen.(0) <- read_float ();
  screen.(1) <- read_float ();
  screen.(2) <- read_float ();
  (* ‰ñ“]Šp *)
  let v1 = rad (read_float ()) in
  let cos_v1 = cos v1 in
  let sin_v1 = sin v1 in
  let v2 = rad (read_float ()) in
  let cos_v2 = cos v2 in
  let sin_v2 = sin v2 in
  (* ƒXƒNƒŠ[ƒ“–Ê‚Ì‰œs‚«•ûŒü‚ÌƒxƒNƒgƒ‹ ’‹“_‚©‚ç‚Ì‹——£200‚ğ‚©‚¯‚é *)
  screenz_dir.(0) <- cos_v1 *. sin_v2 *. 200.0;
  screenz_dir.(1) <- sin_v1 *. -200.0;
  screenz_dir.(2) <- cos_v1 *. cos_v2 *. 200.0;
  (* ƒXƒNƒŠ[ƒ“–ÊX•ûŒü‚ÌƒxƒNƒgƒ‹ *)
  screenx_dir.(0) <- cos_v2;
  screenx_dir.(1) <- 0.0;
  screenx_dir.(2) <- fneg sin_v2;
  (* ƒXƒNƒŠ[ƒ“–ÊY•ûŒü‚ÌƒxƒNƒgƒ‹ *)
  screeny_dir.(0) <- fneg sin_v1 *. sin_v2;
  screeny_dir.(1) <- fneg cos_v1;
  screeny_dir.(2) <- fneg sin_v1 *. cos_v2;
  (* ‹“_ˆÊ’uƒxƒNƒgƒ‹(â‘ÎÀ•W) *)
  viewpoint.(0) <- screen.(0) -. screenz_dir.(0);
  viewpoint.(1) <- screen.(1) -. screenz_dir.(1);
  viewpoint.(2) <- screen.(2) -. screenz_dir.(2)

in

(* ŒõŒ¹î•ñ‚Ì“Ç‚İ‚İ *)
let rec read_light _ =

  let nl = read_int () in

  (* ŒõüŠÖŒW *)
  let l1 = rad (read_float ()) in
  let sl1 = sin l1 in
  light.(1) <- fneg sl1;
  let l2 = rad (read_float ()) in
  let cl1 = cos l1 in
  let sl2 = sin l2 in
  light.(0) <- cl1 *. sl2;
  let cl2 = cos l2 in
  light.(2) <- cl1 *. cl2;
  beam.(0) <- read_float ()

in

(* Œ³‚Ì2ŸŒ`®s—ñ A ‚É—¼‘¤‚©‚ç‰ñ“]s—ñ R ‚ğ‚©‚¯‚½s—ñ R^t * A * R ‚ğì‚é *)
(* R ‚Í x,y,z²‚ÉŠÖ‚·‚é‰ñ“]s—ñ‚ÌÏ R(z)R(y)R(x) *)
(* ƒXƒNƒŠ[ƒ“À•W‚Ì‚½‚ßAy²‰ñ“]‚Ì‚İŠp“x‚Ì•„†‚ª‹t *)

let rec rotate_quadratic_matrix abc rot =
  (* ‰ñ“]s—ñ‚ÌÏ R(z)R(y)R(x) ‚ğŒvZ‚·‚é *)
  let cos_x = cos rot.(0) in
  let sin_x = sin rot.(0) in
  let cos_y = cos rot.(1) in
  let sin_y = sin rot.(1) in
  let cos_z = cos rot.(2) in
  let sin_z = sin rot.(2) in

  let m00 = cos_y *. cos_z in
  let m01 = sin_x *. sin_y *. cos_z -. cos_x *. sin_z in
  let m02 = cos_x *. sin_y *. cos_z +. sin_x *. sin_z in

  let m10 = cos_y *. sin_z in
  let m11 = sin_x *. sin_y *. sin_z +. cos_x *. cos_z in
  let m12 = cos_x *. sin_y *. sin_z -. sin_x *. cos_z in

  let m20 = fneg sin_y in
  let m21 = sin_x *. cos_y in
  let m22 = cos_x *. cos_y in

  (* a, b, c‚ÌŒ³‚Ì’l‚ğƒoƒbƒNƒAƒbƒv *)
  let ao = abc.(0) in
  let bo = abc.(1) in
  let co = abc.(2) in

  (* R^t * A * R ‚ğŒvZ *)

  (* X^2, Y^2, Z^2¬•ª *)
  abc.(0) <- ao *. fsqr m00 +. bo *. fsqr m10 +. co *. fsqr m20;
  abc.(1) <- ao *. fsqr m01 +. bo *. fsqr m11 +. co *. fsqr m21;
  abc.(2) <- ao *. fsqr m02 +. bo *. fsqr m12 +. co *. fsqr m22;

  (* ‰ñ“]‚É‚æ‚Á‚Ä¶‚¶‚½ XY, YZ, ZX¬•ª *)
  rot.(0) <- 2.0 *. (ao *. m01 *. m02 +. bo *. m11 *. m12 +. co *. m21 *. m22);
  rot.(1) <- 2.0 *. (ao *. m00 *. m02 +. bo *. m10 *. m12 +. co *. m20 *. m22);
  rot.(2) <- 2.0 *. (ao *. m00 *. m01 +. bo *. m10 *. m11 +. co *. m20 *. m21)

in

(**** ƒIƒuƒWƒFƒNƒg1‚Â‚Ìƒf[ƒ^‚Ì“Ç‚İ‚İ ****)
let rec read_nth_object n =

  let texture = read_int () in
  if texture <> -1 then
    (
      let form = read_int () in
      let refltype = read_int () in
      let isrot_p = read_int () in

      let abc = create_array 3 0.0 in
      abc.(0) <- read_float ();
      abc.(1) <- read_float (); (* 5 *)
      abc.(2) <- read_float ();

      let xyz = create_array 3 0.0 in
      xyz.(0) <- read_float ();
      xyz.(1) <- read_float ();
      xyz.(2) <- read_float ();

      let m_invert = fisneg (read_float ()) in (* 10 *)

      let reflparam = create_array 2 0.0 in
      reflparam.(0) <- read_float (); (* diffuse *)
      reflparam.(1) <- read_float (); (* hilight *)

      let color = create_array 3 0.0 in
      color.(0) <- read_float ();
      color.(1) <- read_float ();
      color.(2) <- read_float (); (* 15 *)

      let rotation = create_array 3 0.0 in
      if isrot_p <> 0 then
	(
	 rotation.(0) <- rad (read_float ());
	 rotation.(1) <- rad (read_float ());
	 rotation.(2) <- rad (read_float ())
	)
      else ();

      (* ƒpƒ‰ƒ[ƒ^‚Ì³‹K‰» *)

      (* ’: ‰º‹L³‹K‰» (form = 2) QÆ *)
      let m_invert2 = if form = 2 then true else m_invert in
      let ctbl = create_array 4 0.0 in
      (* ‚±‚±‚©‚ç‚ ‚Æ‚Í abc ‚Æ rotation ‚µ‚©‘€ì‚µ‚È‚¢B*)
      let obj =
	(texture, form, refltype, isrot_p,
	 abc, xyz, (* x-z *)
	 m_invert2,
	 reflparam, (* reflection paramater *)
	 color, (* color *)
	 rotation, (* rotation *)
         ctbl (* constant table *)
	) in
      objects.(n) <- obj;

      if form = 3 then
	(
	  (* 2Ÿ‹È–Ê: X,Y,Z ƒTƒCƒY‚©‚ç2ŸŒ`®s—ñ‚Ì‘ÎŠp¬•ª‚Ö *)
	 let a = abc.(0) in
	 abc.(0) <- if fiszero a then 0.0 else sgn a /. fsqr a; (* X^2 ¬•ª *)
	 let b = abc.(1) in
	 abc.(1) <- if fiszero b then 0.0 else sgn b /. fsqr b; (* Y^2 ¬•ª *)
	 let c = abc.(2) in
	 abc.(2) <- if fiszero c then 0.0 else sgn c /. fsqr c  (* Z^2 ¬•ª *)
	)
      else if form = 2 then
	(* •½–Ê: –@üƒxƒNƒgƒ‹‚ğ³‹K‰», ‹É«‚ğ•‰‚É“ˆê *)
	vecunit_sgn abc (not m_invert)
      else ();

      (* 2ŸŒ`®s—ñ‚É‰ñ“]•ÏŠ·‚ğ{‚· *)
      if isrot_p <> 0 then
	rotate_quadratic_matrix abc rotation
      else ();

      true
     )
  else
    false (* ƒf[ƒ^‚ÌI—¹ *)
in

(**** •¨‘Ìƒf[ƒ^‘S‘Ì‚Ì“Ç‚İ‚İ ****)
let rec read_object n =
  if n < 60 then
    if read_nth_object n then
      read_object (n + 1)
    else
      n_objects.(0) <- n
  else () (* failwith "too many objects" *)
in

let rec read_all_object _ =
  read_object 0
in

(**** AND, OR ƒlƒbƒgƒ[ƒN‚Ì“Ç‚İ‚İ ****)

(* ƒlƒbƒgƒ[ƒN1‚Â‚ğ“Ç‚İ‚İƒxƒNƒgƒ‹‚É‚µ‚Ä•Ô‚· *)
let rec read_net_item length =
  let item = read_int () in
  if item = -1 then create_array (length + 1) (-1)
  else
    let v = read_net_item (length + 1) in
    (v.(length) <- item; v)
in

let rec read_or_network length =
  let net = read_net_item 0 in
  if net.(0) = -1 then
    create_array (length + 1) net
  else
    let v = read_or_network (length + 1) in
    (v.(length) <- net; v)
in

let rec read_and_network n =
  let net = read_net_item 0 in
  if net.(0) = -1 then ()
  else (
    and_net.(n) <- net;
    read_and_network (n + 1)
  )
in

let rec read_parameter _ =
  (
   read_screen_settings();
   read_light();
   read_all_object ();
   read_and_network 0;
   or_net.(0) <- read_or_network 0
  )
in

(******************************************************************************
   ’¼ü‚ÆƒIƒuƒWƒFƒNƒg‚ÌŒğ“_‚ğ‹‚ß‚éŠÖ”ŒQ
 *****************************************************************************)

(* solver :
   ƒIƒuƒWƒFƒNƒg (‚Ì index) ‚ÆAƒxƒNƒgƒ‹ L, P ‚ğó‚¯‚Æ‚èA
   ’¼ü Lt + P ‚ÆAƒIƒuƒWƒFƒNƒg‚Æ‚ÌŒğ“_‚ğ‹‚ß‚éB
   Œğ“_‚ª‚È‚¢ê‡‚Í 0 ‚ğAŒğ“_‚ª‚ ‚éê‡‚Í‚»‚êˆÈŠO‚ğ•Ô‚·B
   ‚±‚Ì•Ô‚è’l‚Í nvector ‚ÅŒğ“_‚Ì–@üƒxƒNƒgƒ‹‚ğ‹‚ß‚éÛ‚É•K—vB
   (’¼•û‘Ì‚Ìê‡)
   Œğ“_‚ÌÀ•W‚Í t ‚Ì’l‚Æ‚µ‚Ä solver_dist ‚ÉŠi”[‚³‚ê‚éB
*)

(* ’¼•û‘Ì‚Ìw’è‚³‚ê‚½–Ê‚ÉÕ“Ë‚·‚é‚©‚Ç‚¤‚©”»’è‚·‚é *)
(* i0 : –Ê‚É‚’¼‚È²‚Ìindex X:0, Y:1, Z:2         i2,i3‚Í‘¼‚Ì2²‚Ìindex *)
let rec solver_rect_surface m dirvec b0 b1 b2 i0 i1 i2  =
  if fiszero dirvec.(i0) then false else
  let abc = o_param_abc m in
  let d = fneg_cond (xor (o_isinvert m) (fisneg dirvec.(i0))) abc.(i0) in

  let d2 = (d -. b0) /. dirvec.(i0) in
  if fless (fabs (d2 *. dirvec.(i1) +. b1)) abc.(i1) then
    if fless (fabs (d2 *. dirvec.(i2) +. b2)) abc.(i2) then
      (solver_dist.(0) <- d2; true)
    else false
  else false
in


(***** ’¼•û‘ÌƒIƒuƒWƒFƒNƒg‚Ìê‡ ****)
let rec solver_rect m dirvec b0 b1 b2 =
  if      solver_rect_surface m dirvec b0 b1 b2 0 1 2 then 1   (* YZ •½–Ê *)
  else if solver_rect_surface m dirvec b1 b2 b0 1 2 0 then 2   (* ZX •½–Ê *)
  else if solver_rect_surface m dirvec b2 b0 b1 2 0 1 then 3   (* XY •½–Ê *)
  else                                                     0
in


(* •½–ÊƒIƒuƒWƒFƒNƒg‚Ìê‡ *)
let rec solver_surface m dirvec b0 b1 b2 =
  (* “_‚Æ•½–Ê‚Ì•„†‚Â‚«‹——£ *)
  (* •½–Ê‚Í‹É«‚ª•‰‚É“ˆê‚³‚ê‚Ä‚¢‚é *)
  let abc = o_param_abc m in
  let d = veciprod dirvec abc in
  if fispos d then (
    solver_dist.(0) <- fneg (veciprod2 abc b0 b1 b2) /. d;
    1
   ) else 0
in


(* 3•Ï”2ŸŒ`® v^t A v ‚ğŒvZ *)
(* ‰ñ“]‚ª–³‚¢ê‡‚Í‘ÎŠp•”•ª‚Ì‚İŒvZ‚·‚ê‚Î—Ç‚¢ *)
let rec quadratic m v0 v1 v2 =
  let diag_part =
    fsqr v0 *. o_param_a m +. fsqr v1 *. o_param_b m +. fsqr v2 *. o_param_c m
  in
  if o_isrot m = 0 then
    diag_part
  else
    diag_part
      +. v1 *. v2 *. o_param_r1 m
      +. v2 *. v0 *. o_param_r2 m
      +. v0 *. v1 *. o_param_r3 m
in

(* 3•Ï”‘o1ŸŒ`® v^t A w ‚ğŒvZ *)
(* ‰ñ“]‚ª–³‚¢ê‡‚Í A ‚Ì‘ÎŠp•”•ª‚Ì‚İŒvZ‚·‚ê‚Î—Ç‚¢ *)
let rec bilinear m v0 v1 v2 w0 w1 w2 =
  let diag_part =
    v0 *. w0 *. o_param_a m
      +. v1 *. w1 *. o_param_b m
      +. v2 *. w2 *. o_param_c m
  in
  if o_isrot m = 0 then
    diag_part
  else
    diag_part +. fhalf
      ((v2 *. w1 +. v1 *. w2) *. o_param_r1 m
	 +. (v0 *. w2 +. v2 *. w0) *. o_param_r2 m
	 +. (v0 *. w1 +. v1 *. w0) *. o_param_r3 m)
in


(* 2Ÿ‹È–Ê‚Ü‚½‚Í‰~‚Ìê‡ *)
(* 2ŸŒ`®‚Å•\Œ»‚³‚ê‚½‹È–Ê x^t A x - (0 ‚© 1) = 0 ‚Æ ’¼ü base + dirvec*t ‚Ì
   Œğ“_‚ğ‹‚ß‚éB‹Èü‚Ì•û’ö®‚É x = base + dirvec*t ‚ğ‘ã“ü‚µ‚Ät‚ğ‹‚ß‚éB
   ‚Â‚Ü‚è (base + dirvec*t)^t A (base + dirvec*t) - (0 ‚© 1) = 0A
   “WŠJ‚·‚é‚Æ (dirvec^t A dirvec)*t^2 + 2*(dirvec^t A base)*t  +
   (base^t A base) - (0‚©1) = 0 A‚æ‚Á‚Ät‚ÉŠÖ‚·‚é2Ÿ•û’ö®‚ğ‰ğ‚¯‚Î—Ç‚¢B*)

let rec solver_second m dirvec b0 b1 b2 =

  (* ‰ğ‚ÌŒö® (-b' } sqrt(b'^2 - a*c)) / a  ‚ğg—p(b' = b/2) *)
  (* a = dirvec^t A dirvec *)
  let aa = quadratic m dirvec.(0) dirvec.(1) dirvec.(2) in

  if fiszero aa then
    0 (* ³Šm‚É‚Í‚±‚Ìê‡‚à1Ÿ•û’ö®‚Ì‰ğ‚ª‚ ‚é‚ªA–³‹‚µ‚Ä‚à’Êí‚Í‘åä•v *)
  else (

    (* b' = b/2 = dirvec^t A base   *)
    let bb = bilinear m dirvec.(0) dirvec.(1) dirvec.(2) b0 b1 b2 in
    (* c = base^t A base  - (0‚©1)  *)
    let cc0 = quadratic m b0 b1 b2 in
    let cc = if o_form m = 3 then cc0 -. 1.0 else cc0 in
    (* ”»•Ê® *)
    let d = fsqr bb -. aa *. cc in

    if fispos d then (
      let sd = sqrt d in
      let t1 = if o_isinvert m then sd else fneg sd in
      (solver_dist.(0) <- (t1 -. bb) /.  aa; 1)
     )
    else
      0
   )
in

(**** solver ‚ÌƒƒCƒ“ƒ‹[ƒ`ƒ“ ****)
let rec solver index dirvec org =
  let m = objects.(index) in
  (* ’¼ü‚Ìn“_‚ğ•¨‘Ì‚ÌŠî€ˆÊ’u‚É‡‚í‚¹‚Ä•½sˆÚ“® *)
  let b0 =  org.(0) -. o_param_x m in
  let b1 =  org.(1) -. o_param_y m in
  let b2 =  org.(2) -. o_param_z m in
  let m_shape = o_form m in
  (* •¨‘Ì‚Ìí—Ş‚É‰‚¶‚½•â•ŠÖ”‚ğŒÄ‚Ô *)
  if m_shape = 1 then       solver_rect m dirvec b0 b1 b2    (* ’¼•û‘Ì *)
  else if m_shape = 2 then  solver_surface m dirvec b0 b1 b2 (* •½–Ê *)
  else                      solver_second m dirvec b0 b1 b2  (* 2Ÿ‹È–Ê/‰~ *)
in

(******************************************************************************
   solver‚Ìƒe[ƒuƒ‹g—p‚‘¬”Å
 *****************************************************************************)
(*
   ’Êí”Åsolver ‚Æ“¯—lA’¼ü start + t * dirvec ‚Æ•¨‘Ì‚ÌŒğ“_‚ğ t ‚Ì’l‚Æ‚µ‚Ä•Ô‚·
   t ‚Ì’l‚Í solver_dist‚ÉŠi”[

   solver_fast ‚ÍA’¼ü‚Ì•ûŒüƒxƒNƒgƒ‹ dirvec ‚É‚Â‚¢‚Äì‚Á‚½ƒe[ƒuƒ‹‚ğg—p
   “à•”“I‚É solver_rect_fast, solver_surface_fast, solver_second_fast‚ğŒÄ‚Ô

   solver_fast2 ‚ÍAdirvec‚Æ’¼ü‚Ìn“_ start ‚»‚ê‚¼‚ê‚Éì‚Á‚½ƒe[ƒuƒ‹‚ğg—p
   ’¼•û‘Ì‚É‚Â‚¢‚Ä‚Ístart‚Ìƒe[ƒuƒ‹‚É‚æ‚é‚‘¬‰»‚Í‚Å‚«‚È‚¢‚Ì‚ÅAsolver_fast‚Æ
   “¯‚¶‚­ solver_rect_fast‚ğ“à•”“I‚ÉŒÄ‚ÔB‚»‚êˆÈŠO‚Ì•¨‘Ì‚É‚Â‚¢‚Ä‚Í
   solver_surface_fast2‚Ü‚½‚Ísolver_second_fast2‚ğ“à•”“I‚ÉŒÄ‚Ô
   •Ï”dconst‚Í•ûŒüƒxƒNƒgƒ‹Asconst‚Ín“_‚ÉŠÖ‚·‚éƒe[ƒuƒ‹
*)

(***** solver_rect‚Ìdirvecƒe[ƒuƒ‹g—p‚‘¬”Å ******)
let rec solver_rect_fast m v dconst b0 b1 b2 =
  let d0 = (dconst.(0) -. b0) *. dconst.(1) in
  if  (* YZ•½–Ê‚Æ‚ÌÕ“Ë”»’è *)
    if fless (fabs (d0 *. v.(1) +. b1)) (o_param_b m) then
      if fless (fabs (d0 *. v.(2) +. b2)) (o_param_c m) then
	not (fiszero dconst.(1))
      else false
    else false
  then
    (solver_dist.(0) <- d0; 1)
  else let d1 = (dconst.(2) -. b1) *. dconst.(3) in
  if  (* ZX•½–Ê‚Æ‚ÌÕ“Ë”»’è *)
    if fless (fabs (d1 *. v.(0) +. b0)) (o_param_a m) then
      if fless (fabs (d1 *. v.(2) +. b2)) (o_param_c m) then
	not (fiszero dconst.(3))
      else false
    else false
  then
    (solver_dist.(0) <- d1; 2)
  else let d2 = (dconst.(4) -. b2) *. dconst.(5) in
  if  (* XY•½–Ê‚Æ‚ÌÕ“Ë”»’è *)
    if fless (fabs (d2 *. v.(0) +. b0)) (o_param_a m) then
      if fless (fabs (d2 *. v.(1) +. b1)) (o_param_b m) then
	not (fiszero dconst.(5))
      else false
    else false
  then
    (solver_dist.(0) <- d2; 3)
  else
    0
in

(**** solver_surface‚Ìdirvecƒe[ƒuƒ‹g—p‚‘¬”Å ******)
let rec solver_surface_fast m dconst b0 b1 b2 =
  if fisneg dconst.(0) then (
    solver_dist.(0) <-
      dconst.(1) *. b0 +. dconst.(2) *. b1 +. dconst.(3) *. b2;
    1
   ) else 0
in

(**** solver_second ‚Ìdirvecƒe[ƒuƒ‹g—p‚‘¬”Å ******)
let rec solver_second_fast m dconst b0 b1 b2 =

  let aa = dconst.(0) in
  if fiszero aa then
    0
  else
    let neg_bb = dconst.(1) *. b0 +. dconst.(2) *. b1 +. dconst.(3) *. b2 in
    let cc0 = quadratic m b0 b1 b2 in
    let cc = if o_form m = 3 then cc0 -. 1.0 else cc0 in
    let d = (fsqr neg_bb) -. aa *. cc in
    if fispos d then (
      if o_isinvert m then
	solver_dist.(0) <- (neg_bb +. sqrt d) *. dconst.(4)
      else
	solver_dist.(0) <- (neg_bb -. sqrt d) *. dconst.(4);
      1)
    else 0
in

(**** solver ‚Ìdirvecƒe[ƒuƒ‹g—p‚‘¬”Å *******)
let rec solver_fast index dirvec org =
  let m = objects.(index) in
  let b0 = org.(0) -. o_param_x m in
  let b1 = org.(1) -. o_param_y m in
  let b2 = org.(2) -. o_param_z m in
  let dconsts = d_const dirvec in
  let dconst = dconsts.(index) in
  let m_shape = o_form m in
  if m_shape = 1 then
    solver_rect_fast m (d_vec dirvec) dconst b0 b1 b2
  else if m_shape = 2 then
    solver_surface_fast m dconst b0 b1 b2
  else
    solver_second_fast m dconst b0 b1 b2
in




(* solver_surface‚Ìdirvec+startƒe[ƒuƒ‹g—p‚‘¬”Å *)
let rec solver_surface_fast2 m dconst sconst b0 b1 b2 =
  if fisneg dconst.(0) then (
    solver_dist.(0) <- dconst.(0) *. sconst.(3);
    1
   ) else 0
in

(* solver_second‚Ìdirvec+startƒe[ƒuƒ‹g—p‚‘¬”Å *)
let rec solver_second_fast2 m dconst sconst b0 b1 b2 =

  let aa = dconst.(0) in
  if fiszero aa then
    0
  else
    let neg_bb = dconst.(1) *. b0 +. dconst.(2) *. b1 +. dconst.(3) *. b2 in
    let cc = sconst.(3) in
    let d = (fsqr neg_bb) -. aa *. cc in
    if fispos d then (
      if o_isinvert m then
	solver_dist.(0) <- (neg_bb +. sqrt d) *. dconst.(4)
      else
	solver_dist.(0) <- (neg_bb -. sqrt d) *. dconst.(4);
      1)
    else 0
in

(* solver‚ÌAdirvec+startƒe[ƒuƒ‹g—p‚‘¬”Å *)
let rec solver_fast2 index dirvec =
  let m = objects.(index) in
  let sconst = o_param_ctbl m in
  let b0 = sconst.(0) in
  let b1 = sconst.(1) in
  let b2 = sconst.(2) in
  let dconsts = d_const dirvec in
  let dconst = dconsts.(index) in
  let m_shape = o_form m in
  if m_shape = 1 then
    solver_rect_fast m (d_vec dirvec) dconst b0 b1 b2
  else if m_shape = 2 then
    solver_surface_fast2 m dconst sconst b0 b1 b2
  else
    solver_second_fast2 m dconst sconst b0 b1 b2
in

(******************************************************************************
   •ûŒüƒxƒNƒgƒ‹‚Ì’è”ƒe[ƒuƒ‹‚ğŒvZ‚·‚éŠÖ”ŒQ
 *****************************************************************************)

(* ’¼•û‘ÌƒIƒuƒWƒFƒNƒg‚É‘Î‚·‚é‘Oˆ— *)
let rec setup_rect_table vec m =
  let const = create_array 6 0.0 in

  if fiszero vec.(0) then (* YZ•½–Ê *)
    const.(1) <- 0.0
  else (
    (* –Ê‚Ì X À•W *)
    const.(0) <- fneg_cond (xor (o_isinvert m) (fisneg vec.(0))) (o_param_a m);
    (* •ûŒüƒxƒNƒgƒ‹‚ğ‰½”{‚·‚ê‚ÎX•ûŒü‚É1i‚Ş‚© *)
    const.(1) <- 1.0 /. vec.(0)
  );
  if fiszero vec.(1) then (* ZX•½–Ê : YZ•½–Ê‚Æ“¯—l*)
    const.(3) <- 0.0
  else (
    const.(2) <- fneg_cond (xor (o_isinvert m) (fisneg vec.(1))) (o_param_b m);
    const.(3) <- 1.0 /. vec.(1)
  );
  if fiszero vec.(2) then (* XY•½–Ê : YZ•½–Ê‚Æ“¯—l*)
    const.(5) <- 0.0
  else (
    const.(4) <- fneg_cond (xor (o_isinvert m) (fisneg vec.(2))) (o_param_c m);
    const.(5) <- 1.0 /. vec.(2)
  );
  const
in

(* •½–ÊƒIƒuƒWƒFƒNƒg‚É‘Î‚·‚é‘Oˆ— *)
let rec setup_surface_table vec m =
  let const = create_array 4 0.0 in
  let d =
    vec.(0) *. o_param_a m +. vec.(1) *. o_param_b m +. vec.(2) *. o_param_c m
  in
  if fispos d then (
    (* •ûŒüƒxƒNƒgƒ‹‚ğ‰½”{‚·‚ê‚Î•½–Ê‚Ì‚’¼•ûŒü‚É 1 i‚Ş‚© *)
    const.(0) <- -1.0 /. d;
    (* ‚ ‚é“_‚Ì•½–Ê‚©‚ç‚Ì‹——£‚ª•ûŒüƒxƒNƒgƒ‹‰½ŒÂ•ª‚©‚ğ“±‚­3ŸˆêŒ`®‚ÌŒW” *)
    const.(1) <- fneg (o_param_a m /. d);
    const.(2) <- fneg (o_param_b m /. d);
    const.(3) <- fneg (o_param_c m /. d)
   ) else
    const.(0) <- 0.0;
  const

in

(* 2Ÿ‹È–Ê‚É‘Î‚·‚é‘Oˆ— *)
let rec setup_second_table v m =
  let const = create_array 5 0.0 in

  let aa = quadratic m v.(0) v.(1) v.(2) in
  let c1 = fneg (v.(0) *. o_param_a m) in
  let c2 = fneg (v.(1) *. o_param_b m) in
  let c3 = fneg (v.(2) *. o_param_c m) in

  const.(0) <- aa;  (* 2Ÿ•û’ö®‚Ì a ŒW” *)

  (* b' = dirvec^t A start ‚¾‚ªA(dirvec^t A)‚Ì•”•ª‚ğŒvZ‚µconst.(1:3)‚ÉŠi”[B
     b' ‚ğ‹‚ß‚é‚É‚Í‚±‚ÌƒxƒNƒgƒ‹‚Æstart‚Ì“àÏ‚ğæ‚ê‚Î—Ç‚¢B•„†‚Í‹t‚É‚·‚é *)
  if o_isrot m <> 0 then (
    const.(1) <- c1 -. fhalf (v.(2) *. o_param_r2 m +. v.(1) *. o_param_r3 m);
    const.(2) <- c2 -. fhalf (v.(2) *. o_param_r1 m +. v.(0) *. o_param_r3 m);
    const.(3) <- c3 -. fhalf (v.(1) *. o_param_r1 m +. v.(0) *. o_param_r2 m)
   ) else (
    const.(1) <- c1;
    const.(2) <- c2;
    const.(3) <- c3
   );
  if not (fiszero aa) then
    const.(4) <- 1.0 /. aa (* aŒW”‚Ì‹t”‚ğ‹‚ßA‰ğ‚ÌŒö®‚Å‚ÌŠ„‚èZ‚ğÁ‹ *)
  else ();
  const

in

(* ŠeƒIƒuƒWƒFƒNƒg‚É‚Â‚¢‚Ä•â•ŠÖ”‚ğŒÄ‚ñ‚Åƒe[ƒuƒ‹‚ğì‚é *)
let rec iter_setup_dirvec_constants dirvec index =
  if index >= 0 then (
    let m = objects.(index) in
    let dconst = (d_const dirvec) in
    let v = d_vec dirvec in
    let m_shape = o_form m in
    if m_shape = 1 then  (* rect *)
      dconst.(index) <- setup_rect_table v m
    else if m_shape = 2 then  (* surface *)
      dconst.(index) <- setup_surface_table v m
    else                      (* second *)
      dconst.(index) <- setup_second_table v m;

    iter_setup_dirvec_constants dirvec (index - 1)
  ) else ()
in

let rec setup_dirvec_constants dirvec =
  iter_setup_dirvec_constants dirvec (n_objects.(0) - 1)
in

(******************************************************************************
   ’¼ü‚Ìn“_‚ÉŠÖ‚·‚éƒe[ƒuƒ‹‚ğŠeƒIƒuƒWƒFƒNƒg‚É‘Î‚µ‚ÄŒvZ‚·‚éŠÖ”ŒQ
 *****************************************************************************)

let rec setup_startp_constants p index =
  if index >= 0 then (
    let obj = objects.(index) in
    let sconst = o_param_ctbl obj in
    let m_shape = o_form obj in
    sconst.(0) <- p.(0) -. o_param_x obj;
    sconst.(1) <- p.(1) -. o_param_y obj;
    sconst.(2) <- p.(2) -. o_param_z obj;
    if m_shape = 2 then (* surface *)
      sconst.(3) <-
	veciprod2 (o_param_abc obj) sconst.(0) sconst.(1) sconst.(2)
    else if m_shape > 2 then (* second *)
      let cc0 = quadratic obj sconst.(0) sconst.(1) sconst.(2) in
      sconst.(3) <- if m_shape = 3 then cc0 -. 1.0 else cc0
    else ();
    setup_startp_constants p (index - 1)
   ) else ()
in

let rec setup_startp p =
  veccpy startp_fast p;
  setup_startp_constants p (n_objects.(0) - 1)
in

(******************************************************************************
   —^‚¦‚ç‚ê‚½“_‚ªƒIƒuƒWƒFƒNƒg‚ÉŠÜ‚Ü‚ê‚é‚©‚Ç‚¤‚©‚ğ”»’è‚·‚éŠÖ”ŒQ
 *****************************************************************************)

(**** “_ q ‚ªƒIƒuƒWƒFƒNƒg m ‚ÌŠO•”‚©‚Ç‚¤‚©‚ğ”»’è‚·‚é ****)

(* ’¼•û‘Ì *)
let rec is_rect_outside m p0 p1 p2 =
  if
    if (fless (fabs p0) (o_param_a m)) then
      if (fless (fabs p1) (o_param_b m)) then
	fless (fabs p2) (o_param_c m)
      else false
    else false
  then o_isinvert m else not (o_isinvert m)
in

(* •½–Ê *)
let rec is_plane_outside m p0 p1 p2 =
  let w = veciprod2 (o_param_abc m) p0 p1 p2 in
  not (xor (o_isinvert m) (fisneg w))
in

(* 2Ÿ‹È–Ê *)
let rec is_second_outside m p0 p1 p2 =
  let w = quadratic m p0 p1 p2 in
  let w2 = if o_form m = 3 then w -. 1.0 else w in
  not (xor (o_isinvert m) (fisneg w2))
in

(* •¨‘Ì‚Ì’†SÀ•W‚É•½sˆÚ“®‚µ‚½ã‚ÅA“KØ‚È•â•ŠÖ”‚ğŒÄ‚Ô *)
let rec is_outside m q0 q1 q2 =
  let p0 = q0 -. o_param_x m in
  let p1 = q1 -. o_param_y m in
  let p2 = q2 -. o_param_z m in
  let m_shape = o_form m in
  if m_shape = 1 then
    is_rect_outside m p0 p1 p2
  else if m_shape = 2 then
    is_plane_outside m p0 p1 p2
  else
    is_second_outside m p0 p1 p2
in

(**** “_ q ‚ª AND ƒlƒbƒgƒ[ƒN iand ‚Ì“à•”‚É‚ ‚é‚©‚Ç‚¤‚©‚ğ”»’è ****)
let rec check_all_inside ofs iand q0 q1 q2 =
  let head = iand.(ofs) in
  if head = -1 then
    true
  else (
    if is_outside objects.(head) q0 q1 q2 then
      false
    else
      check_all_inside (ofs + 1) iand q0 q1 q2
   )
in

(******************************************************************************
   Õ“Ë“_‚ª‘¼‚Ì•¨‘Ì‚Ì‰e‚É“ü‚Á‚Ä‚¢‚é‚©”Û‚©‚ğ”»’è‚·‚éŠÖ”ŒQ
 *****************************************************************************)

(* “_ intersection_point ‚©‚çAŒõüƒxƒNƒgƒ‹‚Ì•ûŒü‚É’H‚èA   *)
(* •¨‘Ì‚É‚Ô‚Â‚©‚é (=‰e‚É‚Í‚¢‚Á‚Ä‚¢‚é) ‚©”Û‚©‚ğ”»’è‚·‚éB*)

(**** AND ƒlƒbƒgƒ[ƒN iand ‚Ì‰e“à‚©‚Ç‚¤‚©‚Ì”»’è ****)
let rec shadow_check_and_group iand_ofs and_group =
  if and_group.(iand_ofs) = -1 then
    false
  else
    let obj = and_group.(iand_ofs) in
    let t0 = solver_fast obj light_dirvec intersection_point in
    let t0p = solver_dist.(0) in
    if (if t0 <> 0 then fless t0p (-0.2) else false) then
      (* Q: Œğ“_‚ÌŒó•âBÀÛ‚É‚·‚×‚Ä‚ÌƒIƒuƒWƒFƒNƒg‚É *)
      (* “ü‚Á‚Ä‚¢‚é‚©‚Ç‚¤‚©‚ğ’²‚×‚éB*)
      let t = t0p +. 0.01 in
      let q0 = light.(0) *. t +. intersection_point.(0) in
      let q1 = light.(1) *. t +. intersection_point.(1) in
      let q2 = light.(2) *. t +. intersection_point.(2) in
      if check_all_inside 0 and_group q0 q1 q2 then
	true
      else
	shadow_check_and_group (iand_ofs + 1) and_group
	  (* Ÿ‚ÌƒIƒuƒWƒFƒNƒg‚©‚çŒó•â“_‚ğ’T‚· *)
    else
      (* Œğ“_‚ª‚È‚¢ê‡: ‹É«‚ª³(“à‘¤‚ª^)‚Ìê‡A    *)
      (* AND ƒlƒbƒg‚Ì‹¤’Ê•”•ª‚Í‚»‚Ì“à•”‚ÉŠÜ‚Ü‚ê‚é‚½‚ßA*)
      (* Œğ“_‚Í‚È‚¢‚±‚Æ‚Í©–¾B’Tõ‚ğ‘Å‚¿Ø‚éB        *)
      if o_isinvert (objects.(obj)) then
	shadow_check_and_group (iand_ofs + 1) and_group
      else
	false
in

(**** OR ƒOƒ‹[ƒv or_group ‚Ì‰e‚©‚Ç‚¤‚©‚Ì”»’è ****)
let rec shadow_check_one_or_group ofs or_group =
  let head = or_group.(ofs) in
  if head = -1 then
    false
  else (
    let and_group = and_net.(head) in
    let shadow_p = shadow_check_and_group 0 and_group in
    if shadow_p then
      true
    else
      shadow_check_one_or_group (ofs + 1) or_group
   )
in

(**** OR ƒOƒ‹[ƒv‚Ì—ñ‚Ì‚Ç‚ê‚©‚Ì‰e‚É“ü‚Á‚Ä‚¢‚é‚©‚Ç‚¤‚©‚Ì”»’è ****)
let rec shadow_check_one_or_matrix ofs or_matrix =
  let head = or_matrix.(ofs) in
  let range_primitive = head.(0) in
  if range_primitive = -1 then (* ORs—ñ‚ÌI—¹ƒ}[ƒN *)
    false
  else
    if (* range primitive ‚ª–³‚¢‚©A‚Ü‚½‚Írange_primitive‚ÆŒğ‚í‚é–‚ğŠm”F *)
      if range_primitive = 99 then      (* range primitive ‚ª–³‚¢ *)
	true
      else              (* range_primitive‚ª‚ ‚é *)
	let t = solver_fast range_primitive light_dirvec intersection_point in
        (* range primitive ‚Æ‚Ô‚Â‚©‚ç‚È‚¯‚ê‚Î *)
        (* or group ‚Æ‚ÌŒğ“_‚Í‚È‚¢            *)
	if t <> 0 then
          if fless solver_dist.(0) (-0.1) then
            if shadow_check_one_or_group 1 head then
              true
	    else false
	  else false
	else false
    then
      if (shadow_check_one_or_group 1 head) then
	true (* Œğ“_‚ª‚ ‚é‚Ì‚ÅA‰e‚É“ü‚é–‚ª”»–¾B’TõI—¹ *)
      else
	shadow_check_one_or_matrix (ofs + 1) or_matrix (* Ÿ‚Ì—v‘f‚ğ‚· *)
    else
      shadow_check_one_or_matrix (ofs + 1) or_matrix (* Ÿ‚Ì—v‘f‚ğ‚· *)

in

(******************************************************************************
   Œõü‚Æ•¨‘Ì‚ÌŒğ·”»’è
 *****************************************************************************)

(**** ‚ ‚éANDƒlƒbƒgƒ[ƒN‚ªAƒŒƒCƒgƒŒ[ƒX‚Ì•ûŒü‚É‘Î‚µA****)
(**** Œğ“_‚ª‚ ‚é‚©‚Ç‚¤‚©‚ğ’²‚×‚éB                     ****)
let rec solve_each_element iand_ofs and_group dirvec =
  let iobj = and_group.(iand_ofs) in
  if iobj = -1 then ()
  else (
    let t0 = solver iobj dirvec startp in
    if t0 <> 0 then
      (
       (* Œğ“_‚ª‚ ‚é‚ÍA‚»‚ÌŒğ“_‚ª‘¼‚Ì—v‘f‚Ì’†‚ÉŠÜ‚Ü‚ê‚é‚©‚Ç‚¤‚©’²‚×‚éB*)
       (* ¡‚Ü‚Å‚Ì’†‚ÅÅ¬‚Ì t ‚Ì’l‚Æ”ä‚×‚éB*)
       let t0p = solver_dist.(0) in

       if (fless 0.0 t0p) then
	 if (fless t0p tmin.(0)) then
	   (
	    let t = t0p +. 0.01 in
	    let q0 = dirvec.(0) *. t +. startp.(0) in
	    let q1 = dirvec.(1) *. t +. startp.(1) in
	    let q2 = dirvec.(2) *. t +. startp.(2) in
	    if check_all_inside 0 and_group q0 q1 q2 then
	      (
		tmin.(0) <- t;
		vecset intersection_point q0 q1 q2;
		intersected_object_id.(0) <- iobj;
		intsec_rectside.(0) <- t0
	       )
	    else ()
	   )
	 else ()
       else ();
       solve_each_element (iand_ofs + 1) and_group dirvec
      )
    else
      (* Œğ“_‚ª‚È‚­A‚µ‚©‚à‚»‚Ì•¨‘Ì‚Í“à‘¤‚ª^‚È‚ç‚±‚êˆÈãŒğ“_‚Í‚È‚¢ *)
      if o_isinvert (objects.(iobj)) then
	solve_each_element (iand_ofs + 1) and_group dirvec
      else ()

   )
in

(**** 1‚Â‚Ì OR-group ‚É‚Â‚¢‚ÄŒğ“_‚ğ’²‚×‚é ****)
let rec solve_one_or_network ofs or_group dirvec =
  let head = or_group.(ofs) in
  if head <> -1 then (
    let and_group = and_net.(head) in
    solve_each_element 0 and_group dirvec;
    solve_one_or_network (ofs + 1) or_group dirvec
   ) else ()
in

(**** ORƒ}ƒgƒŠƒNƒX‘S‘Ì‚É‚Â‚¢‚ÄŒğ“_‚ğ’²‚×‚éB****)
let rec trace_or_matrix ofs or_network dirvec =
  let head = or_network.(ofs) in
  let range_primitive = head.(0) in
  if range_primitive = -1 then (* ‘SƒIƒuƒWƒFƒNƒgI—¹ *)
    ()
  else (
    if range_primitive = 99 (* range primitive ‚È‚µ *)
    then (solve_one_or_network 1 head dirvec)
    else
      (
	(* range primitive ‚ÌÕ“Ë‚µ‚È‚¯‚ê‚ÎŒğ“_‚Í‚È‚¢ *)
       let t = solver range_primitive dirvec startp in
       if t <> 0 then
	 let tp = solver_dist.(0) in
	 if fless tp tmin.(0)
	 then (solve_one_or_network 1 head dirvec)
	 else ()
       else ()
      );
    trace_or_matrix (ofs + 1) or_network dirvec
  )
in

(**** ƒgƒŒ[ƒX–{‘Ì ****)
(* ƒgƒŒ[ƒXŠJn“_ ViewPoint ‚ÆA‚»‚Ì“_‚©‚ç‚ÌƒXƒLƒƒƒ“•ûŒüƒxƒNƒgƒ‹ *)
(* Vscan ‚©‚çAŒğ“_ crashed_point ‚ÆÕ“Ë‚µ‚½ƒIƒuƒWƒFƒNƒg         *)
(* crashed_object ‚ğ•Ô‚·BŠÖ”©‘Ì‚Ì•Ô‚è’l‚ÍŒğ“_‚Ì—L–³‚Ì^‹U’lB *)
let rec judge_intersection dirvec = (
  tmin.(0) <- (1000000000.0);
  trace_or_matrix 0 (or_net.(0)) dirvec;
  let t = tmin.(0) in

  if (fless (-0.1) t) then
    (fless t 100000000.0)
  else false
 )
in

(******************************************************************************
   Œõü‚Æ•¨‘Ì‚ÌŒğ·”»’è ‚‘¬”Å
 *****************************************************************************)

let rec solve_each_element_fast iand_ofs and_group dirvec =
  let vec = (d_vec dirvec) in
  let iobj = and_group.(iand_ofs) in
  if iobj = -1 then ()
  else (
    let t0 = solver_fast2 iobj dirvec in
    if t0 <> 0 then
      (
        (* Œğ“_‚ª‚ ‚é‚ÍA‚»‚ÌŒğ“_‚ª‘¼‚Ì—v‘f‚Ì’†‚ÉŠÜ‚Ü‚ê‚é‚©‚Ç‚¤‚©’²‚×‚éB*)
        (* ¡‚Ü‚Å‚Ì’†‚ÅÅ¬‚Ì t ‚Ì’l‚Æ”ä‚×‚éB*)
       let t0p = solver_dist.(0) in

       if (fless 0.0 t0p) then
	 if (fless t0p tmin.(0)) then
	   (
	    let t = t0p +. 0.01 in
	    let q0 = vec.(0) *. t +. startp_fast.(0) in
	    let q1 = vec.(1) *. t +. startp_fast.(1) in
	    let q2 = vec.(2) *. t +. startp_fast.(2) in
	    if check_all_inside 0 and_group q0 q1 q2 then
	      (
		tmin.(0) <- t;
		vecset intersection_point q0 q1 q2;
		intersected_object_id.(0) <- iobj;
		intsec_rectside.(0) <- t0
	       )
	    else ()
	   )
	 else ()
       else ();
       solve_each_element_fast (iand_ofs + 1) and_group dirvec
      )
    else
       (* Œğ“_‚ª‚È‚­A‚µ‚©‚à‚»‚Ì•¨‘Ì‚Í“à‘¤‚ª^‚È‚ç‚±‚êˆÈãŒğ“_‚Í‚È‚¢ *)
       if o_isinvert (objects.(iobj)) then
	 solve_each_element_fast (iand_ofs + 1) and_group dirvec
       else ()
   )
in

(**** 1‚Â‚Ì OR-group ‚É‚Â‚¢‚ÄŒğ“_‚ğ’²‚×‚é ****)
let rec solve_one_or_network_fast ofs or_group dirvec =
  let head = or_group.(ofs) in
  if head <> -1 then (
    let and_group = and_net.(head) in
    solve_each_element_fast 0 and_group dirvec;
    solve_one_or_network_fast (ofs + 1) or_group dirvec
   ) else ()
in

(**** ORƒ}ƒgƒŠƒNƒX‘S‘Ì‚É‚Â‚¢‚ÄŒğ“_‚ğ’²‚×‚éB****)
let rec trace_or_matrix_fast ofs or_network dirvec =
  let head = or_network.(ofs) in
  let range_primitive = head.(0) in
  if range_primitive = -1 then (* ‘SƒIƒuƒWƒFƒNƒgI—¹ *)
    ()
  else (
    if range_primitive = 99 (* range primitive ‚È‚µ *)
    then solve_one_or_network_fast 1 head dirvec
    else
      (
	(* range primitive ‚ÌÕ“Ë‚µ‚È‚¯‚ê‚ÎŒğ“_‚Í‚È‚¢ *)
       let t = solver_fast2 range_primitive dirvec in
       if t <> 0 then
	 let tp = solver_dist.(0) in
	 if fless tp tmin.(0)
	 then (solve_one_or_network_fast 1 head dirvec)
	 else ()
       else ()
      );
    trace_or_matrix_fast (ofs + 1) or_network dirvec
   )
in

(**** ƒgƒŒ[ƒX–{‘Ì ****)
let rec judge_intersection_fast dirvec =
(
  tmin.(0) <- (1000000000.0);
  trace_or_matrix_fast 0 (or_net.(0)) dirvec;
  let t = tmin.(0) in

  if (fless (-0.1) t) then
    (fless t 100000000.0)
  else false
)
in

(******************************************************************************
   •¨‘Ì‚ÆŒõ‚ÌŒğ·“_‚Ì–@üƒxƒNƒgƒ‹‚ğ‹‚ß‚éŠÖ”
 *****************************************************************************)

(**** Œğ“_‚©‚ç–@üƒxƒNƒgƒ‹‚ğŒvZ‚·‚é ****)
(* Õ“Ë‚µ‚½ƒIƒuƒWƒFƒNƒg‚ğ‹‚ß‚½Û‚Ì solver ‚Ì•Ô‚è’l‚ğ *)
(* •Ï” intsec_rectside Œo—R‚Å“n‚µ‚Ä‚â‚é•K—v‚ª‚ ‚éB  *)
(* nvector ‚àƒOƒ[ƒoƒ‹B *)

let rec get_nvector_rect dirvec =
  let rectside = intsec_rectside.(0) in
  (* solver ‚Ì•Ô‚è’l‚Í‚Ô‚Â‚©‚Á‚½–Ê‚Ì•ûŒü‚ğ¦‚· *)
  vecbzero nvector;
  nvector.(rectside-1) <- fneg (sgn (dirvec.(rectside-1)))
in

(* •½–Ê *)
let rec get_nvector_plane m =
  (* m_invert ‚Íí‚É true ‚Ì‚Í‚¸ *)
  nvector.(0) <- fneg (o_param_a m); (* if m_invert then fneg m_a else m_a *)
  nvector.(1) <- fneg (o_param_b m);
  nvector.(2) <- fneg (o_param_c m)
in

(* 2Ÿ‹È–Ê :  grad x^t A x = 2 A x ‚ğ³‹K‰»‚·‚é *)
let rec get_nvector_second m =
  let p0 = intersection_point.(0) -. o_param_x m in
  let p1 = intersection_point.(1) -. o_param_y m in
  let p2 = intersection_point.(2) -. o_param_z m in

  let d0 = p0 *. o_param_a m in
  let d1 = p1 *. o_param_b m in
  let d2 = p2 *. o_param_c m in

  if o_isrot m = 0 then (
    nvector.(0) <- d0;
    nvector.(1) <- d1;
    nvector.(2) <- d2
   ) else (
    nvector.(0) <- d0 +. fhalf (p1 *. o_param_r3 m +. p2 *. o_param_r2 m);
    nvector.(1) <- d1 +. fhalf (p0 *. o_param_r3 m +. p2 *. o_param_r1 m);
    nvector.(2) <- d2 +. fhalf (p0 *. o_param_r2 m +. p1 *. o_param_r1 m)
   );
  vecunit_sgn nvector (o_isinvert m)

in

let rec get_nvector m dirvec =
  let m_shape = o_form m in
  if m_shape = 1 then
    get_nvector_rect dirvec
  else if m_shape = 2 then
    get_nvector_plane m
  else (* 2Ÿ‹È–Ê or ‘Ì *)
    get_nvector_second m
  (* retval = nvector *)
in

(******************************************************************************
   •¨‘Ì•\–Ê‚ÌF(F•t‚«ŠgU”½Ë—¦)‚ğ‹‚ß‚é
 *****************************************************************************)

(**** Œğ“_ã‚ÌƒeƒNƒXƒ`ƒƒ‚ÌF‚ğŒvZ‚·‚é ****)
let rec utexture m p =
  let m_tex = o_texturetype m in
  (* Šî–{‚ÍƒIƒuƒWƒFƒNƒg‚ÌF *)
  texture_color.(0) <- o_color_red m;
  texture_color.(1) <- o_color_green m;
  texture_color.(2) <- o_color_blue m;
  if m_tex = 1 then
    (
     (* zx•ûŒü‚Ìƒ`ƒFƒbƒJ[–Í—l (G) *)
     let w1 = p.(0) -. o_param_x m in
     let flag1 =
       let d1 = (floor (w1 *. 0.05)) *. 20.0 in
      fless (w1 -. d1) 10.0
     in
     let w3 = p.(2) -. o_param_z m in
     let flag2 =
       let d2 = (floor (w3 *. 0.05)) *. 20.0 in
       fless (w3 -. d2) 10.0
     in
     texture_color.(1) <-
       if flag1
       then (if flag2 then 255.0 else 0.0)
       else (if flag2 then 0.0 else 255.0)
    )
  else if m_tex = 2 then
    (* y²•ûŒü‚ÌƒXƒgƒ‰ƒCƒv (R-G) *)
    (
      let w2 = fsqr (sin (p.(1) *. 0.25)) in
      texture_color.(0) <- 255.0 *. w2;
      texture_color.(1) <- 255.0 *. (1.0 -. w2)
    )
  else if m_tex = 3 then
    (* ZX–Ê•ûŒü‚Ì“¯S‰~ (G-B) *)
    (
      let w1 = p.(0) -. o_param_x m in
      let w3 = p.(2) -. o_param_z m in
      let w2 = sqrt (fsqr w1 +. fsqr w3) /. 10.0 in
      let w4 =  (w2 -. floor w2) *. 3.1415927 in
      let cws = fsqr (cos w4) in
      texture_color.(1) <- cws *. 255.0;
      texture_color.(2) <- (1.0 -. cws) *. 255.0
    )
  else if m_tex = 4 then (
    (* ‹…–Êã‚Ì”Á“_ (B) *)
    let w1 = (p.(0) -. o_param_x m) *. (sqrt (o_param_a m)) in
    let w3 = (p.(2) -. o_param_z m) *. (sqrt (o_param_c m)) in
    let w4 = (fsqr w1) +. (fsqr w3) in
    let w7 =
      if fless (fabs w1) 1.0e-4 then
	15.0 (* atan +infty = pi/2 *)
      else
	let w5 = fabs (w3 /. w1)
	in
	((atan w5) *. 30.0) /. 3.1415927
    in
    let w9 = w7 -. (floor w7) in

    let w2 = (p.(1) -. o_param_y m) *. (sqrt (o_param_b m)) in
    let w8 =
      if fless (fabs w4) 1.0e-4 then
	15.0
      else
	let w6 = fabs (w2 /. w4)
	in ((atan w6) *. 30.0) /. 3.1415927
    in
    let w10 = w8 -. (floor w8) in
    let w11 = 0.15 -. (fsqr (0.5 -. w9)) -. (fsqr (0.5 -. w10)) in
    let w12 = if fisneg w11 then 0.0 else w11 in
    texture_color.(2) <- (255.0 *. w12) /. 0.3
   )
  else ()
in

(******************************************************************************
   Õ“Ë“_‚É“–‚½‚éŒõŒ¹‚Ì’¼ÚŒõ‚Æ”½ËŒõ‚ğŒvZ‚·‚éŠÖ”ŒQ
 *****************************************************************************)

(* “–‚½‚Á‚½Œõ‚É‚æ‚éŠgUŒõ‚Æ•sŠ®‘S‹¾–Ê”½ËŒõ‚É‚æ‚éŠñ—^‚ğRGB’l‚É‰ÁZ *)
let rec add_light bright hilight hilight_scale =

  (* ŠgUŒõ *)
  if fispos bright then
    vecaccum rgb bright texture_color
  else ();

  (* •sŠ®‘S‹¾–Ê”½Ë cos ^4 ƒ‚ƒfƒ‹ *)
  if fispos hilight then (
    let ihl = fsqr (fsqr hilight) *. hilight_scale in
    rgb.(0) <- rgb.(0) +. ihl;
    rgb.(1) <- rgb.(1) +. ihl;
    rgb.(2) <- rgb.(2) +. ihl
  ) else ()
in

(* Še•¨‘Ì‚É‚æ‚éŒõŒ¹‚Ì”½ËŒõ‚ğŒvZ‚·‚éŠÖ”(’¼•û‘Ì‚Æ•½–Ê‚Ì‚İ) *)
let rec trace_reflections index diffuse hilight_scale dirvec =

  if index >= 0 then (
    let rinfo = reflections.(index) in (* ‹¾•½–Ê‚Ì”½Ëî•ñ *)
    let dvec = r_dvec rinfo in    (* ”½ËŒõ‚Ì•ûŒüƒxƒNƒgƒ‹(Œõ‚Æ‹tŒü‚« *)

    (*”½ËŒõ‚ğ‹t‚É‚½‚Ç‚èAÀÛ‚É‚»‚Ì‹¾–Ê‚É“–‚½‚ê‚ÎA”½ËŒõ‚ª“Í‚­‰Â”\«—L‚è *)
    if judge_intersection_fast dvec then
      let surface_id = intersected_object_id.(0) * 4 + intsec_rectside.(0) in
      if surface_id = r_surface_id rinfo then
	(* ‹¾–Ê‚Æ‚ÌÕ“Ë“_‚ªŒõŒ¹‚Ì‰e‚É‚È‚Á‚Ä‚¢‚È‚¯‚ê‚Î”½ËŒõ‚Í“Í‚­ *)
        if not (shadow_check_one_or_matrix 0 or_net.(0)) then
	  (* “Í‚¢‚½”½ËŒõ‚É‚æ‚é RGB¬•ª‚Ö‚ÌŠñ—^‚ğ‰ÁZ *)
          let p = veciprod nvector (d_vec dvec) in
          let scale = r_bright rinfo in
          let bright = scale *. diffuse *. p in
          let hilight = scale *. veciprod dirvec (d_vec dvec) in
          add_light bright hilight hilight_scale
        else ()
      else ()
    else ();
    trace_reflections (index - 1) diffuse hilight_scale dirvec
  ) else ()

in

(******************************************************************************
   ’¼ÚŒõ‚ğ’ÇÕ‚·‚é
 *****************************************************************************)
let rec trace_ray nref energy dirvec pixel dist =
  if nref <= 4 then (
    let surface_ids = p_surface_ids pixel in
    if judge_intersection dirvec then (
    (* ƒIƒuƒWƒFƒNƒg‚É‚Ô‚Â‚©‚Á‚½ê‡ *)
      let obj_id = intersected_object_id.(0) in
      let obj = objects.(obj_id) in
      let m_surface = o_reflectiontype obj in
      let diffuse = o_diffuse obj *. energy in

      get_nvector obj dirvec; (* –@üƒxƒNƒgƒ‹‚ğ get *)
      veccpy startp intersection_point;  (* Œğ·“_‚ğV‚½‚ÈŒõ‚Ì”­Ë“_‚Æ‚·‚é *)
      utexture obj intersection_point; (*ƒeƒNƒXƒ`ƒƒ‚ğŒvZ *)

      (* pixel tuple‚Éî•ñ‚ğŠi”[‚·‚é *)
      surface_ids.(nref) <- obj_id * 4 + intsec_rectside.(0);
      let intersection_points = p_intersection_points pixel in
      veccpy intersection_points.(nref) intersection_point;

      (* ŠgU”½Ë—¦‚ª0.5ˆÈã‚Ìê‡‚Ì‚İŠÔÚŒõ‚ÌƒTƒ“ƒvƒŠƒ“ƒO‚ğs‚¤ *)
      let calc_diffuse = p_calc_diffuse pixel in
      if fless (o_diffuse obj) 0.5 then
	calc_diffuse.(nref) <- false
      else (
	calc_diffuse.(nref) <- true;
	let energya = p_energy pixel in
	veccpy energya.(nref) texture_color;
	vecscale energya.(nref) ((1.0 /. 256.0) *. diffuse);
	let nvectors = p_nvectors pixel in
	veccpy nvectors.(nref) nvector
       );

      let w = (-2.0) *. veciprod dirvec nvector in
      (* ”½ËŒõ‚Ì•ûŒü‚ÉƒgƒŒ[ƒX•ûŒü‚ğ•ÏX *)
      vecaccum dirvec w nvector;

      let hilight_scale = energy *. o_hilight obj in

      (* ŒõŒ¹Œõ‚ª’¼Ú“Í‚­ê‡ARGB¬•ª‚É‚±‚ê‚ğ‰Á–¡‚·‚é *)
      if not (shadow_check_one_or_matrix 0 or_net.(0)) then
        let bright = fneg (veciprod nvector light) *. diffuse in
        let hilight = fneg (veciprod dirvec light) in
        add_light bright hilight hilight_scale
      else ();

      (* ŒõŒ¹Œõ‚Ì”½ËŒõ‚ª–³‚¢‚©’T‚· *)
      setup_startp intersection_point;
      trace_reflections (n_reflections.(0)-1) diffuse hilight_scale dirvec;

      (* d‚İ‚ª 0.1‚æ‚è‘½‚­c‚Á‚Ä‚¢‚½‚çA‹¾–Ê”½ËŒ³‚ğ’ÇÕ‚·‚é *)
      if fless 0.1 energy then (

	if(nref < 4) then
	  surface_ids.(nref+1) <- -1
	else ();

	if m_surface = 2 then (   (* Š®‘S‹¾–Ê”½Ë *)
	  let energy2 = energy *. (1.0 -. o_diffuse obj) in
	  trace_ray (nref+1) energy2 dirvec pixel (dist +. tmin.(0))
	 ) else ()

	  ) else ()

     ) else (
      (* ‚Ç‚Ì•¨‘Ì‚É‚à“–‚½‚ç‚È‚©‚Á‚½ê‡BŒõŒ¹‚©‚ç‚ÌŒõ‚ğ‰Á–¡ *)

      surface_ids.(nref) <- -1;

      if nref <> 0 then (
	let hl = fneg (veciprod dirvec light) in
        (* 90‹‚ğ’´‚¦‚éê‡‚Í0 (Œõ‚È‚µ) *)
	if fispos hl then
	  (
	   (* ƒnƒCƒ‰ƒCƒg‹­“x‚ÍŠp“x‚Ì cos^3 ‚É”ä—á *)
	   let ihl = fsqr hl *. hl *. energy *. beam.(0) in
	   rgb.(0) <- rgb.(0) +. ihl;
	   rgb.(1) <- rgb.(1) +. ihl;
	   rgb.(2) <- rgb.(2) +. ihl
          )
	else ()
       ) else ()
     )
   ) else ()
in


(******************************************************************************
   ŠÔÚŒõ‚ğ’ÇÕ‚·‚é
 *****************************************************************************)

(* ‚ ‚é“_‚ª“Á’è‚Ì•ûŒü‚©‚çó‚¯‚éŠÔÚŒõ‚Ì‹­‚³‚ğŒvZ‚·‚é *)
(* ŠÔÚŒõ‚Ì•ûŒüƒxƒNƒgƒ‹ dirvec‚ÉŠÖ‚µ‚Ä‚Í’è”ƒe[ƒuƒ‹‚ªì‚ç‚ê‚Ä‚¨‚èAÕ“Ë”»’è
   ‚ª‚‘¬‚És‚í‚ê‚éB•¨‘Ì‚É“–‚½‚Á‚½‚çA‚»‚ÌŒã‚Ì”½Ë‚Í’ÇÕ‚µ‚È‚¢ *)
let rec trace_diffuse_ray dirvec energy =

  (* ‚Ç‚ê‚©‚Ì•¨‘Ì‚É“–‚½‚é‚©’²‚×‚é *)
  if judge_intersection_fast dirvec then
    let obj = objects.(intersected_object_id.(0)) in
    get_nvector obj (d_vec dirvec);
    utexture obj intersection_point;

    (* ‚»‚Ì•¨‘Ì‚ª•úË‚·‚éŒõ‚Ì‹­‚³‚ğ‹‚ß‚éB’¼ÚŒõŒ¹Œõ‚Ì‚İ‚ğŒvZ *)
    if not (shadow_check_one_or_matrix 0 or_net.(0)) then
      let br =  fneg (veciprod nvector light) in
      let bright = (if fispos br then br else 0.0) in
      vecaccum diffuse_ray (energy *. bright *. o_diffuse obj) texture_color
    else ()
  else ()
in

(* ‚ ‚ç‚©‚¶‚ßŒˆ‚ß‚ç‚ê‚½•ûŒüƒxƒNƒgƒ‹‚Ì”z—ñ‚É‘Î‚µAŠeƒxƒNƒgƒ‹‚Ì•ûŠp‚©‚ç—ˆ‚é
   ŠÔÚŒõ‚Ì‹­‚³‚ğƒTƒ“ƒvƒŠƒ“ƒO‚µ‚Ä‰ÁZ‚·‚é *)
let rec iter_trace_diffuse_rays dirvec_group nvector org index =
  if index >= 0 then (
    let p = veciprod (d_vec dirvec_group.(index)) nvector in

    (* ”z—ñ‚Ì 2n ”Ô–Ú‚Æ 2n+1 ”Ô–Ú‚É‚ÍŒİ‚¢‚É‹tŒü‚Ì•ûŒüƒxƒNƒgƒ‹‚ª“ü‚Á‚Ä‚¢‚é
       –@üƒxƒNƒgƒ‹‚Æ“¯‚¶Œü‚«‚Ì•¨‚ğ‘I‚ñ‚Åg‚¤ *)
    if fisneg p then
      trace_diffuse_ray dirvec_group.(index + 1) (p /. -150.0)
    else
      trace_diffuse_ray dirvec_group.(index) (p /. 150.0);

    iter_trace_diffuse_rays dirvec_group nvector org (index - 2)
   ) else ()
in

(* —^‚¦‚ç‚ê‚½•ûŒüƒxƒNƒgƒ‹‚ÌW‡‚É‘Î‚µA‚»‚Ì•ûŒü‚ÌŠÔÚŒõ‚ğƒTƒ“ƒvƒŠƒ“ƒO‚·‚é *)
let rec trace_diffuse_rays dirvec_group nvector org =
  setup_startp org;
  (* ”z—ñ‚Ì 2n ”Ô–Ú‚Æ 2n+1 ”Ô–Ú‚É‚ÍŒİ‚¢‚É‹tŒü‚Ì•ûŒüƒxƒNƒgƒ‹‚ª“ü‚Á‚Ä‚¢‚ÄA
     –@üƒxƒNƒgƒ‹‚Æ“¯‚¶Œü‚«‚Ì•¨‚Ì‚İƒTƒ“ƒvƒŠƒ“ƒO‚Ég‚í‚ê‚é *)
  (* ‘S•”‚Å 120 / 2 = 60–{‚ÌƒxƒNƒgƒ‹‚ğ’ÇÕ *)
  iter_trace_diffuse_rays dirvec_group nvector org 118
in

(* ”¼‹…•ûŒü‚Ì‘S•”‚Å300–{‚ÌƒxƒNƒgƒ‹‚Ì‚¤‚¿A‚Ü‚¾’ÇÕ‚µ‚Ä‚¢‚È‚¢c‚è‚Ì240–{‚Ì
   ƒxƒNƒgƒ‹‚É‚Â‚¢‚ÄŠÔÚŒõ’ÇÕ‚·‚éB60–{‚ÌƒxƒNƒgƒ‹’ÇÕ‚ğ4ƒZƒbƒgs‚¤ *)
let rec trace_diffuse_ray_80percent group_id nvector org =

  if group_id <> 0 then
    trace_diffuse_rays dirvecs.(0) nvector org
  else ();

  if group_id <> 1 then
    trace_diffuse_rays dirvecs.(1) nvector org
  else ();

  if group_id <> 2 then
    trace_diffuse_rays dirvecs.(2) nvector org
  else ();

  if group_id <> 3 then
    trace_diffuse_rays dirvecs.(3) nvector org
  else ();

  if group_id <> 4 then
    trace_diffuse_rays dirvecs.(4) nvector org
  else ()

in

(* ã‰º¶‰E4“_‚ÌŠÔÚŒõ’ÇÕŒ‹‰Ê‚ğg‚í‚¸A300–{‘S•”‚ÌƒxƒNƒgƒ‹‚ğ’ÇÕ‚µ‚ÄŠÔÚŒõ‚ğ
   ŒvZ‚·‚éB20%(60–{)‚Í’ÇÕÏ‚È‚Ì‚ÅAc‚è80%(240–{)‚ğ’ÇÕ‚·‚é *)
let rec calc_diffuse_using_1point pixel nref =

  let ray20p = p_received_ray_20percent pixel in
  let nvectors = p_nvectors pixel in
  let intersection_points = p_intersection_points pixel in
  let energya = p_energy pixel in

  veccpy diffuse_ray ray20p.(nref);
  trace_diffuse_ray_80percent
    (p_group_id pixel)
    nvectors.(nref)
    intersection_points.(nref);
  vecaccumv rgb energya.(nref) diffuse_ray

in

(* ©•ª‚Æã‰º¶‰E4“_‚Ì’ÇÕŒ‹‰Ê‚ğ‰ÁZ‚µ‚ÄŠÔÚŒõ‚ğ‹‚ß‚éB–{—ˆ‚Í 300 –{‚ÌŒõ‚ğ
   ’ÇÕ‚·‚é•K—v‚ª‚ ‚é‚ªA5“_‰ÁZ‚·‚é‚Ì‚Å1“_‚ ‚½‚è60–{(20%)’ÇÕ‚·‚é‚¾‚¯‚ÅÏ‚Ş *)

let rec calc_diffuse_using_5points x prev cur next nref =

  let r_up = p_received_ray_20percent prev.(x) in
  let r_left = p_received_ray_20percent cur.(x-1) in
  let r_center = p_received_ray_20percent cur.(x) in
  let r_right = p_received_ray_20percent cur.(x+1) in
  let r_down = p_received_ray_20percent next.(x) in

  veccpy diffuse_ray r_up.(nref);
  vecadd diffuse_ray r_left.(nref);
  vecadd diffuse_ray r_center.(nref);
  vecadd diffuse_ray r_right.(nref);
  vecadd diffuse_ray r_down.(nref);

  let energya = p_energy cur.(x) in
  vecaccumv rgb energya.(nref) diffuse_ray

in

(* ã‰º¶‰E4“_‚ğg‚í‚¸‚É’¼ÚŒõ‚ÌŠeÕ“Ë“_‚É‚¨‚¯‚éŠÔÚóŒõ‚ğŒvZ‚·‚é *)
let rec do_without_neighbors pixel nref =
  if nref <= 4 then
    (* Õ“Ë–Ê”Ô†‚ª—LŒø(”ñ•‰)‚©ƒ`ƒFƒbƒN *)
    let surface_ids = p_surface_ids pixel in
    if surface_ids.(nref) >= 0 then (
      let calc_diffuse = p_calc_diffuse pixel in
      if calc_diffuse.(nref) then
	calc_diffuse_using_1point pixel nref
      else ();
      do_without_neighbors pixel (nref + 1)
     ) else ()
  else ()
in

(* ‰æ‘œã‚Åã‰º¶‰E‚É“_‚ª‚ ‚é‚©(—v‚·‚é‚ÉA‰æ‘œ‚Ì’[‚Å–³‚¢–)‚ğŠm”F *)
let rec neighbors_exist x y next =
  if (y + 1) < image_size.(1) then
    if y > 0 then
      if (x + 1) < image_size.(0) then
	if x > 0 then
	  true
	else false
      else false
    else false
  else false
in

let rec get_surface_id pixel index =
  let surface_ids = p_surface_ids pixel in
  surface_ids.(index)
in

(* ã‰º¶‰E4“_‚Ì’¼ÚŒõ’ÇÕ‚ÌŒ‹‰ÊA©•ª‚Æ“¯‚¶–Ê‚ÉÕ“Ë‚µ‚Ä‚¢‚é‚©‚ğƒ`ƒFƒbƒN
   ‚à‚µ“¯‚¶–Ê‚ÉÕ“Ë‚µ‚Ä‚¢‚ê‚ÎA‚±‚ê‚ç4“_‚ÌŒ‹‰Ê‚ğg‚¤‚±‚Æ‚ÅŒvZ‚ğÈ—ªo—ˆ‚é *)
let rec neighbors_are_available x prev cur next nref =
  let sid_center = get_surface_id cur.(x) nref in

  if get_surface_id prev.(x) nref = sid_center then
    if get_surface_id next.(x) nref = sid_center then
      if get_surface_id cur.(x-1) nref = sid_center then
	if get_surface_id cur.(x+1) nref = sid_center then
	  true
	else false
      else false
    else false
  else false
in

(* ’¼ÚŒõ‚ÌŠeÕ“Ë“_‚É‚¨‚¯‚éŠÔÚóŒõ‚Ì‹­‚³‚ğAã‰º¶‰E4“_‚ÌŒ‹‰Ê‚ğg—p‚µ‚ÄŒvZ
   ‚·‚éB‚à‚µã‰º¶‰E4“_‚ÌŒvZŒ‹‰Ê‚ğg‚¦‚È‚¢ê‡‚ÍA‚»‚Ì“_‚Å
   do_without_neighbors‚ÉØ‚è‘Ö‚¦‚é *)

let rec try_exploit_neighbors x y prev cur next nref =
  let pixel = cur.(x) in
  if nref <= 4 then

    (* Õ“Ë–Ê”Ô†‚ª—LŒø(”ñ•‰)‚© *)
    if get_surface_id pixel nref >= 0 then
      (* üˆÍ4“_‚ğ•âŠ®‚Ég‚¦‚é‚© *)
      if neighbors_are_available x prev cur next nref then (

	(* ŠÔÚóŒõ‚ğŒvZ‚·‚éƒtƒ‰ƒO‚ª—§‚Á‚Ä‚¢‚ê‚ÎÀÛ‚ÉŒvZ‚·‚é *)
	let calc_diffuse = p_calc_diffuse pixel in
        if calc_diffuse.(nref) then
	  calc_diffuse_using_5points x prev cur next nref
	else ();

	(* Ÿ‚Ì”½ËÕ“Ë“_‚Ö *)
	try_exploit_neighbors x y prev cur next (nref + 1)
      ) else
	(* üˆÍ4“_‚ğ•âŠ®‚Ég‚¦‚È‚¢‚Ì‚ÅA‚±‚ê‚ç‚ğg‚í‚È‚¢•û–@‚ÉØ‚è‘Ö‚¦‚é *)
	do_without_neighbors cur.(x) nref
    else ()
  else ()
in

(******************************************************************************
   PPMƒtƒ@ƒCƒ‹‚Ì‘‚«‚İŠÖ”
 *****************************************************************************)
let rec write_ppm_header _ =
  (
    print_char 80; (* 'P' *)
    print_char (48 + 3); (* +6 if binary *) (* 48 = '0' *)
    print_char 10;
    print_int image_size.(0);
    print_char 32;
    print_int image_size.(1);
    print_char 32;
    print_int 255;
    print_char 10
  )
in

let rec write_rgb_element x =
  let ix = int_of_float x in
  let elem = if ix > 255 then 255 else if ix < 0 then 0 else ix in
  print_int elem
in

let rec write_rgb _ =
   write_rgb_element rgb.(0); (* Red   *)
   print_char 32;
   write_rgb_element rgb.(1); (* Green *)
   print_char 32;
   write_rgb_element rgb.(2); (* Blue  *)
   print_char 10
in

(******************************************************************************
   ‚ ‚éƒ‰ƒCƒ“‚ÌŒvZ‚É•K—v‚Èî•ñ‚ğW‚ß‚é‚½‚ßŸ‚Ìƒ‰ƒCƒ“‚Ì’ÇÕ‚ğs‚Á‚Ä‚¨‚­ŠÖ”ŒQ
 *****************************************************************************)

(* ŠÔÚŒõ‚ÌƒTƒ“ƒvƒŠƒ“ƒO‚Å‚Íã‰º¶‰E4“_‚ÌŒ‹‰Ê‚ğg‚¤‚Ì‚ÅAŸ‚Ìƒ‰ƒCƒ“‚ÌŒvZ‚ğ
   s‚í‚È‚¢‚ÆÅI“I‚ÈƒsƒNƒZƒ‹‚Ì’l‚ğŒvZ‚Å‚«‚È‚¢ *)

(* ŠÔÚŒõ‚ğ 60–{(20%)‚¾‚¯ŒvZ‚µ‚Ä‚¨‚­ŠÖ” *)
let rec pretrace_diffuse_rays pixel nref =
  if nref <= 4 then

    (* –Ê”Ô†‚ª—LŒø‚© *)
    let sid = get_surface_id pixel nref in
    if sid >= 0 then (
      (* ŠÔÚŒõ‚ğŒvZ‚·‚éƒtƒ‰ƒO‚ª—§‚Á‚Ä‚¢‚é‚© *)
      let calc_diffuse = p_calc_diffuse pixel in
      if calc_diffuse.(nref) then (
	let group_id = p_group_id pixel in
	vecbzero diffuse_ray;

	(* 5‚Â‚Ì•ûŒüƒxƒNƒgƒ‹W‡(Še60–{)‚©‚ç©•ª‚ÌƒOƒ‹[ƒvID‚É‘Î‰‚·‚é•¨‚ğ
	   ˆê‚Â‘I‚ñ‚Å’ÇÕ *)
	let nvectors = p_nvectors pixel in
	let intersection_points = p_intersection_points pixel in
	trace_diffuse_rays
	  dirvecs.(group_id)
	  nvectors.(nref)
	  intersection_points.(nref);
	let ray20p = p_received_ray_20percent pixel in
	veccpy ray20p.(nref) diffuse_ray
       ) else ();
      pretrace_diffuse_rays pixel (nref + 1)
     ) else ()
  else ()
in

(* ŠeƒsƒNƒZƒ‹‚É‘Î‚µ‚Ä’¼ÚŒõ’ÇÕ‚ÆŠÔÚóŒõ‚Ì20%•ª‚ÌŒvZ‚ğs‚¤ *)

let rec pretrace_pixels line x group_id lc0 lc1 lc2 =
  if x >= 0 then (

    let xdisp = scan_pitch.(0) *. float_of_int (x - image_center.(0)) in
    ptrace_dirvec.(0) <- xdisp *. screenx_dir.(0) +. lc0;
    ptrace_dirvec.(1) <- xdisp *. screenx_dir.(1) +. lc1;
    ptrace_dirvec.(2) <- xdisp *. screenx_dir.(2) +. lc2;
    vecunit_sgn ptrace_dirvec false;
    vecbzero rgb;
    veccpy startp viewpoint;

    (* ’¼ÚŒõ’ÇÕ *)
    trace_ray 0 1.0 ptrace_dirvec line.(x) 0.0;
    veccpy (p_rgb line.(x)) rgb;
    p_set_group_id line.(x) group_id;

    (* ŠÔÚŒõ‚Ì20%‚ğ’ÇÕ *)
    pretrace_diffuse_rays line.(x) 0;

    pretrace_pixels line (x-1) (add_mod5 group_id 1) lc0 lc1 lc2

   ) else ()
in

(* ‚ ‚éƒ‰ƒCƒ“‚ÌŠeƒsƒNƒZƒ‹‚É‘Î‚µ’¼ÚŒõ’ÇÕ‚ÆŠÔÚóŒõ20%•ª‚ÌŒvZ‚ğ‚·‚é *)
let rec pretrace_line line y group_id =
  let ydisp = scan_pitch.(0) *. float_of_int (y - image_center.(1)) in

  (* ƒ‰ƒCƒ“‚Ì’†S‚ÉŒü‚©‚¤ƒxƒNƒgƒ‹‚ğŒvZ *)
  let lc0 = ydisp *. screeny_dir.(0) +. screenz_dir.(0) in
  let lc1 = ydisp *. screeny_dir.(1) +. screenz_dir.(1) in
  let lc2 = ydisp *. screeny_dir.(2) +. screenz_dir.(2) in
  pretrace_pixels line (image_size.(0) - 1) group_id lc0 lc1 lc2
in


(******************************************************************************
   ’¼ÚŒõ’ÇÕ‚ÆŠÔÚŒõ20%’ÇÕ‚ÌŒ‹‰Ê‚©‚çÅI“I‚ÈƒsƒNƒZƒ‹’l‚ğŒvZ‚·‚éŠÖ”
 *****************************************************************************)

(* ŠeƒsƒNƒZƒ‹‚ÌÅI“I‚ÈƒsƒNƒZƒ‹’l‚ğŒvZ *)
let rec scan_pixel x y prev cur next =
  if x < image_size.(0) then (

    (* ‚Ü‚¸A’¼ÚŒõ’ÇÕ‚Å“¾‚ç‚ê‚½RGB’l‚ğ“¾‚é *)
    veccpy rgb (p_rgb cur.(x));

    (* Ÿ‚ÉA’¼ÚŒõ‚ÌŠeÕ“Ë“_‚É‚Â‚¢‚ÄAŠÔÚóŒõ‚É‚æ‚éŠñ—^‚ğ‰Á–¡‚·‚é *)
    if neighbors_exist x y next then
      try_exploit_neighbors x y prev cur next 0
    else
      do_without_neighbors cur.(x) 0;

    (* “¾‚ç‚ê‚½’l‚ğPPMƒtƒ@ƒCƒ‹‚Éo—Í *)
    write_rgb ();

    scan_pixel (x + 1) y prev cur next
   ) else ()
in

(* ˆêƒ‰ƒCƒ“•ª‚ÌƒsƒNƒZƒ‹’l‚ğŒvZ *)
let rec scan_line y prev cur next group_id = (

  if y < image_size.(1) then (

    if y < image_size.(1) - 1 then
      pretrace_line next (y + 1) group_id
    else ();
    scan_pixel 0 y prev cur next;
    scan_line (y + 1) cur next prev (add_mod5 group_id 2)
   ) else ()
)
in

(******************************************************************************
   ƒsƒNƒZƒ‹‚Ìî•ñ‚ğŠi”[‚·‚éƒf[ƒ^\‘¢‚ÌŠ„‚è“–‚ÄŠÖ”ŒQ
 *****************************************************************************)

(* 3ŸŒ³ƒxƒNƒgƒ‹‚Ì5—v‘f”z—ñ‚ğŠ„‚è“–‚Ä *)
let rec create_float5x3array _ = (
  let vec = create_array 3 0.0 in
  let array = create_array 5 vec in
  array.(1) <- create_array 3 0.0;
  array.(2) <- create_array 3 0.0;
  array.(3) <- create_array 3 0.0;
  array.(4) <- create_array 3 0.0;
  array
)
in

(* ƒsƒNƒZƒ‹‚ğ•\‚·tuple‚ğŠ„‚è“–‚Ä *)
let rec create_pixel _ =
  let m_rgb = create_array 3 0.0 in
  let m_isect_ps = create_float5x3array() in
  let m_sids = create_array 5 0 in
  let m_cdif = create_array 5 false in
  let m_engy = create_float5x3array() in
  let m_r20p = create_float5x3array() in
  let m_gid = create_array 1 0 in
  let m_nvectors = create_float5x3array() in
  (m_rgb, m_isect_ps, m_sids, m_cdif, m_engy, m_r20p, m_gid, m_nvectors)
in

(* ‰¡•ûŒü1ƒ‰ƒCƒ“’†‚ÌŠeƒsƒNƒZƒ‹—v‘f‚ğŠ„‚è“–‚Ä‚é *)
let rec init_line_elements line n =
  if n >= 0 then (
    line.(n) <- create_pixel();
    init_line_elements line (n-1)
   ) else
    line
in

(* ‰¡•ûŒü1ƒ‰ƒCƒ“•ª‚ÌƒsƒNƒZƒ‹”z—ñ‚ğì‚é *)
let rec create_pixelline _ =
  let line = create_array image_size.(0) (create_pixel()) in
  init_line_elements line (image_size.(0)-2)
in

(******************************************************************************
   ŠÔÚŒõ‚ÌƒTƒ“ƒvƒŠƒ“ƒO‚É‚Â‚©‚¤•ûŒüƒxƒNƒgƒ‹ŒQ‚ğŒvZ‚·‚éŠÖ”ŒQ
 *****************************************************************************)

(* ƒxƒNƒgƒ‹’B‚ªo—ˆ‚é‚¾‚¯ˆê—l‚É•ª•z‚·‚é‚æ‚¤A600–{‚Ì•ûŒüƒxƒNƒgƒ‹‚ÌŒü‚«‚ğ’è‚ß‚é
   —§•û‘Ìã‚ÌŠe–Ê‚É100–{‚¸‚Â•ª•z‚³‚¹A‚³‚ç‚ÉA100–{‚ª—§•û‘Ìã‚Ì–Êã‚Å10 x 10 ‚Ì
   Šiqó‚É•À‚Ô‚æ‚¤‚È”z—ñ‚ğg‚¤B‚±‚Ì”z—ñ‚Å‚Í•ûŠp‚É‚æ‚éƒxƒNƒgƒ‹‚Ì–§“x‚Ì·‚ª
   ‘å‚«‚¢‚Ì‚ÅA‚±‚ê‚É•â³‚ğ‰Á‚¦‚½‚à‚Ì‚ğÅI“I‚É—p‚¢‚é *)

let rec tan x =
  sin(x) /. cos(x)
in

(* ƒxƒNƒgƒ‹’B‚ªo—ˆ‚é‚¾‚¯‹…–Êó‚Éˆê—l‚É•ª•z‚·‚é‚æ‚¤À•W‚ğ•â³‚·‚é *)
let rec adjust_position h ratio =
  let l = sqrt(h*.h +. 0.1) in
  let tan_h = 1.0 /. l in
  let theta_h = atan tan_h in
   let tan_m = tan (theta_h *. ratio) in
  tan_m *. l
in

(* ƒxƒNƒgƒ‹’B‚ªo—ˆ‚é‚¾‚¯‹…–Êó‚Éˆê—l‚É•ª•z‚·‚é‚æ‚¤‚ÈŒü‚«‚ğŒvZ‚·‚é *)
let rec calc_dirvec icount x y rx ry group_id index =
  if icount >= 5 then (
    let l = sqrt(fsqr x +. fsqr y +. 1.0) in
    let vx = x /. l in
    let vy = y /. l in
    let vz = 1.0 /. l in

    (* —§•û‘Ì“I‚É‘ÎÌ‚É•ª•z‚³‚¹‚é *)
    let dgroup = dirvecs.(group_id) in
    vecset (d_vec dgroup.(index))    vx vy vz;
    vecset (d_vec dgroup.(index+40)) vx vz (fneg vy);
    vecset (d_vec dgroup.(index+80)) vz (fneg vx) (fneg vy);
    vecset (d_vec dgroup.(index+1)) (fneg vx) (fneg vy) (fneg vz);
    vecset (d_vec dgroup.(index+41)) (fneg vx) (fneg vz) vy;
    vecset (d_vec dgroup.(index+81)) (fneg vz) vx vy
   ) else
    let x2 = adjust_position y rx in
    calc_dirvec (icount + 1) x2 (adjust_position x2 ry) rx ry group_id index
in

(* —§•û‘Ìã‚Ì 10x10Šiq‚Ìs’†‚ÌŠeƒxƒNƒgƒ‹‚ğŒvZ‚·‚é *)
let rec calc_dirvecs col ry group_id index =
  if col >= 0 then (
    (* ¶”¼•ª *)
    let rx = (float_of_int col) *. 0.2 -. 0.9 in (* —ñ‚ÌÀ•W *)
    calc_dirvec 0 0.0 0.0 rx ry group_id index;
    (* ‰E”¼•ª *)
    let rx2 = (float_of_int col) *. 0.2 +. 0.1 in (* —ñ‚ÌÀ•W *)
    calc_dirvec 0 0.0 0.0 rx2 ry group_id (index + 2);

    calc_dirvecs (col - 1) ry (add_mod5 group_id 1) index
   ) else ()
in

(* —§•û‘Ìã‚Ì10x10Šiq‚ÌŠes‚É‘Î‚µƒxƒNƒgƒ‹‚ÌŒü‚«‚ğŒvZ‚·‚é *)
let rec calc_dirvec_rows row group_id index =
  if row >= 0 then (
    let ry = (float_of_int row) *. 0.2 -. 0.9 in (* s‚ÌÀ•W *)
    calc_dirvecs 4 ry group_id index; (* ˆês•ªŒvZ *)
    calc_dirvec_rows (row - 1) (add_mod5 group_id 2) (index + 4)
   ) else ()
in

(******************************************************************************
   dirvec ‚Ìƒƒ‚ƒŠŠ„‚è“–‚Ä‚ğs‚¤
 *****************************************************************************)


let rec create_dirvec _ =
  let v3 = create_array 3 0.0 in
  let consts = create_array n_objects.(0) v3 in
  (v3, consts)
in

let rec create_dirvec_elements d index =
  if index >= 0 then (
    d.(index) <- create_dirvec();
    create_dirvec_elements d (index - 1)
   ) else ()
in

let rec create_dirvecs index =
  if index >= 0 then (
    dirvecs.(index) <- create_array 120 (create_dirvec());
    create_dirvec_elements dirvecs.(index) 118;
    create_dirvecs (index-1)
   ) else ()
in

(******************************************************************************
   •â•ŠÖ”’B‚ğŒÄ‚Ño‚µ‚Ädirvec‚Ì‰Šú‰»‚ğs‚¤
 *****************************************************************************)

let rec init_dirvec_constants vecset index =
  if index >= 0 then (
    setup_dirvec_constants vecset.(index);
    init_dirvec_constants vecset (index - 1)
   ) else ()
in

let rec init_vecset_constants index =
  if index >= 0 then (
    init_dirvec_constants dirvecs.(index) 119;
    init_vecset_constants (index - 1)
   ) else ()
in

let rec init_dirvecs _ =
  create_dirvecs 4;
  calc_dirvec_rows 9 0 0;
  init_vecset_constants 4
in

(******************************************************************************
   Š®‘S‹¾–Ê”½Ë¬•ª‚ğ‚Â•¨‘Ì‚Ì”½Ëî•ñ‚ğ‰Šú‰»‚·‚é
 *****************************************************************************)

(* ”½Ë•½–Ê‚ğ’Ç‰Á‚·‚é *)
let rec add_reflection index surface_id bright v0 v1 v2 =
  let dvec = create_dirvec() in
  vecset (d_vec dvec) v0 v1 v2; (* ”½ËŒõ‚ÌŒü‚« *)
  setup_dirvec_constants dvec;

  reflections.(index) <- (surface_id, dvec, bright)
in

(* ’¼•û‘Ì‚ÌŠe–Ê‚É‚Â‚¢‚Äî•ñ‚ğ’Ç‰Á‚·‚é *)
let rec setup_rect_reflection obj_id obj =
  let sid = obj_id * 4 in
  let nr = n_reflections.(0) in
  let br = 1.0 -. o_diffuse obj in
  let n0 = fneg light.(0) in
  let n1 = fneg light.(1) in
  let n2 = fneg light.(2) in
  add_reflection nr (sid+1) br light.(0) n1 n2;
  add_reflection (nr+1) (sid+2) br n0 light.(1) n2;
  add_reflection (nr+2) (sid+3) br n0 n1 light.(2);
  n_reflections.(0) <- nr + 3
in

(* •½–Ê‚É‚Â‚¢‚Äî•ñ‚ğ’Ç‰Á‚·‚é *)
let rec setup_surface_reflection obj_id obj =
  let sid = obj_id * 4 + 1 in
  let nr = n_reflections.(0) in
  let br = 1.0 -. o_diffuse obj in
  let p = veciprod light (o_param_abc obj) in

  add_reflection nr sid br
    (2.0 *. o_param_a obj *. p -. light.(0))
    (2.0 *. o_param_b obj *. p -. light.(1))
    (2.0 *. o_param_c obj *. p -. light.(2));
  n_reflections.(0) <- nr + 1
in


(* ŠeƒIƒuƒWƒFƒNƒg‚É‘Î‚µA”½Ë‚·‚é•½–Ê‚ª‚ ‚ê‚Î‚»‚Ìî•ñ‚ğ’Ç‰Á‚·‚é *)
let rec setup_reflections obj_id =
  if obj_id >= 0 then
    let obj = objects.(obj_id) in
    if o_reflectiontype obj = 2 then
      if fless (o_diffuse obj) 1.0 then
	let m_shape = o_form obj in
	(* ’¼•û‘Ì‚Æ•½–Ê‚Ì‚İƒTƒ|[ƒg *)
	if m_shape = 1 then
	  setup_rect_reflection obj_id obj
	else if m_shape = 2 then
	  setup_surface_reflection obj_id obj
	else ()
      else ()
    else ()
  else ()
in

(*****************************************************************************
   ‘S‘Ì‚Ì§Œä
 *****************************************************************************)

(* ƒŒƒCƒgƒŒ‚ÌŠeƒXƒeƒbƒv‚ğs‚¤ŠÖ”‚ğ‡ŸŒÄ‚Ño‚· *)
let rec rt size_x size_y =
(
 image_size.(0) <- size_x;
 image_size.(1) <- size_y;
 image_center.(0) <- size_x / 2;
 image_center.(1) <- size_y / 2;
 scan_pitch.(0) <- 128.0 /. float_of_int size_x;
 let prev = create_pixelline () in
 let cur  = create_pixelline () in
 let next = create_pixelline () in
 read_parameter();
 write_ppm_header ();
 init_dirvecs();
 veccpy (d_vec light_dirvec) light;
 setup_dirvec_constants light_dirvec;
 setup_reflections (n_objects.(0) - 1);
 pretrace_line cur 0 0;
 scan_line 0 prev cur next 2
)
in

let _ = rt 128 128

in ()
