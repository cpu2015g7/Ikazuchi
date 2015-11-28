(* open MiniMLRuntime;; *)

(**************** �����Х��ѿ������ ****************)

(* ���֥������ȤθĿ� *)
let n_objects = create_array 1 0 in

(* ���֥������ȤΥǡ����������٥��ȥ�ʺ���60�ġ�*)
let objects =
  let dummy = create_array 0 0.0 in
  create_array 60 (0, 0, 0, 0, dummy, dummy, false, dummy, dummy, dummy, dummy) in

(* Screen ���濴��ɸ *)
let screen = create_array 3 0.0 in
(* �����κ�ɸ *)
let viewpoint = create_array 3 0.0 in
(* ���������٥��ȥ� (ñ�̥٥��ȥ�) *)
let light = create_array 3 0.0 in
(* ���̥ϥ��饤�ȶ��� (ɸ��=255) *)
let beam = create_array 1 255.0 in
(* AND �ͥåȥ�����ݻ� *)
let and_net = create_array 50 (create_array 1 (-1)) in
(* OR �ͥåȥ�����ݻ� *)
let or_net = create_array 1 (create_array 1 (and_net.(0))) in

(* �ʲ�����Ƚ��롼������֤��ͳ�Ǽ�� *)
(* solver �θ��� �� t ���� *)
let solver_dist = create_array 1 0.0 in
(* ������ľ����ɽ�̤Ǥ����� *)
let intsec_rectside = create_array 1 0 in
(* ȯ�����������κǾ��� t *)
let tmin = create_array 1 (1000000000.0) in
(* �����κ�ɸ *)
let intersection_point = create_array 3 0.0 in
(* ���ͤ������֥��������ֹ� *)
let intersected_object_id = create_array 1 0 in
(* ˡ���٥��ȥ� *)
let nvector = create_array 3 0.0 in
(* �����ο� *)
let texture_color = create_array 3 0.0 in

(* �׻���δ��ܼ������٤��ݻ� *)
let diffuse_ray = create_array 3 0.0 in
(* �����꡼�����������뤵 *)
let rgb = create_array 3 0.0 in

(* ���������� *)
let image_size = create_array 2 0 in
(* �������濴 = ������������Ⱦʬ *)
let image_center = create_array 2 0 in
(* 3������Υԥ�����ֳ� *)
let scan_pitch = create_array 1 0.0 in

(* judge_intersection��Ϳ����������� *)
let startp = create_array 3 0.0 in
(* judge_intersection_fast��Ϳ����������� *)
let startp_fast = create_array 3 0.0 in

(* ���̾��x,y,z����3�������־������ *)
let screenx_dir = create_array 3 0.0 in
let screeny_dir = create_array 3 0.0 in
let screenz_dir = create_array 3 0.0 in

(* ľ�ܸ����פǻȤ��������٥��ȥ� *)
let ptrace_dirvec  = create_array 3 0.0 in

(* ���ܸ�����ץ�󥰤˻Ȥ������٥��ȥ� *)
let dirvecs =
  let dummyf = create_array 0 0.0 in
  let dummyff = create_array 0 dummyf in
  let dummy_vs = create_array 0 (dummyf, dummyff) in
  create_array 5 dummy_vs in

(* ���������������Ѥ������٥��ȥ� *)
let light_dirvec =
  let dummyf2 = create_array 0 0.0 in
  let v3 = create_array 3 0.0 in
  let consts = create_array 60 dummyf2 in
  (v3, consts) in

(* ��ʿ�̤�ȿ�;��� *)
let reflections =
  let dummyf3 = create_array 0 0.0 in
  let dummyff3 = create_array 0 dummyf3 in
  let dummydv = (dummyf3, dummyff3) in
  create_array 180 (0, dummydv, 0.0) in

(* reflections��ͭ�������ǿ� *)

let n_reflections = create_array 1 0 in
(* (*NOMINCAML open MiniMLRuntime;;*)
(*NOMINCAML open Globals;;*)
(*MINCAML*) let true = 1 in
(*MINCAML*) let false = 0 in *)
(*MINCAML*) let rec xor x y = if x then not y else y in

(******************************************************************************
   ���[�e�B���e�B�[
 *****************************************************************************)

(* ���� *)
let rec sgn x =
  if fiszero x then 0.0
  else if fispos x then 1.0
  else -1.0
in

(* �����t���������] *)
let rec fneg_cond cond x =
  if cond then x else fneg x
in

(* (x+y) mod 5 *)
let rec add_mod5 x y =
  let sum = x + y in
  if sum >= 5 then sum - 5 else sum
in

(******************************************************************************
   �x�N�g������̂��߂̃v���~�e�B�u
 *****************************************************************************)

(*
let rec vecprint v =
  (o_param_abc m) inFormat.eprintf "(%f %f %f)" v.(0) v.(1) v.(2)
in
*)

(* �l��� *)
let rec vecset v x y z =
  v.(0) <- x;
  v.(1) <- y;
  v.(2) <- z
in

(* �����l�Ŗ��߂� *)
let rec vecfill v elem =
  v.(0) <- elem;
  v.(1) <- elem;
  v.(2) <- elem
in

(* �돉���� *)
let rec vecbzero v =
  vecfill v 0.0
in

(* �R�s�[ *)
let rec veccpy dest src =
  dest.(0) <- src.(0);
  dest.(1) <- src.(1);
  dest.(2) <- src.(2)
in

(* �����̎��� *)
let rec vecdist2 p q =
  fsqr (p.(0) -. q.(0)) +. fsqr (p.(1) -. q.(1)) +. fsqr (p.(2) -. q.(2))
in

(* ���K�� �[������`�F�b�N���� *)
let rec vecunit v =
  let il = 1.0 /. sqrt(fsqr v.(0) +. fsqr v.(1) +. fsqr v.(2)) in
  v.(0) <- v.(0) *. il;
  v.(1) <- v.(1) *. il;
  v.(2) <- v.(2) *. il
in

(* �����t���K�� �[�����`�F�b�N*)
let rec vecunit_sgn v inv =
  let l = sqrt (fsqr v.(0) +. fsqr v.(1) +. fsqr v.(2)) in
  let il = if fiszero l then 1.0 else if inv then -1.0 /. l else 1.0 /. l in
  v.(0) <- v.(0) *. il;
  v.(1) <- v.(1) *. il;
  v.(2) <- v.(2) *. il
in

(* ���� *)
let rec veciprod v w =
  v.(0) *. w.(0) +. v.(1) *. w.(1) +. v.(2) *. w.(2)
in

(* ���� �����`�����قȂ�� *)
let rec veciprod2 v w0 w1 w2 =
  v.(0) *. w0 +. v.(1) *. w1 +. v.(2) *. w2
in

(* �ʂȃx�N�g���̒萔�{�����Z *)
let rec vecaccum dest scale v =
  dest.(0) <- dest.(0) +. scale *. v.(0);
  dest.(1) <- dest.(1) +. scale *. v.(1);
  dest.(2) <- dest.(2) +. scale *. v.(2)
in

(* �x�N�g���̘a *)
let rec vecadd dest v =
  dest.(0) <- dest.(0) +. v.(0);
  dest.(1) <- dest.(1) +. v.(1);
  dest.(2) <- dest.(2) +. v.(2)
in

(* �x�N�g���v�f���m�̐� *)
let rec vecmul dest v =
  dest.(0) <- dest.(0) *. v.(0);
  dest.(1) <- dest.(1) *. v.(1);
  dest.(2) <- dest.(2) *. v.(2)
in

(* �x�N�g����萔�{ *)
let rec vecscale dest scale =
  dest.(0) <- dest.(0) *. scale;
  dest.(1) <- dest.(1) *. scale;
  dest.(2) <- dest.(2) *. scale
in

(* ���̂Q�x�N�g���̗v�f���m�̐ς��v�Z�����Z *)
let rec vecaccumv dest v w =
  dest.(0) <- dest.(0) +. v.(0) *. w.(0);
  dest.(1) <- dest.(1) +. v.(1) *. w.(1);
  dest.(2) <- dest.(2) +. v.(2) *. w.(2)
in

(******************************************************************************
   �I�u�W�F�N�g�f�[�^�\���ւ̃A�N�Z�X�֐�
 *****************************************************************************)

(* �e�N�X�`���� 0:���� 1:�s���͗l 2:�Ȗ͗l 3:���S�~�͗l 4:���_*)
let rec o_texturetype m =
  let (m_tex, xm_shape, xm_surface, xm_isrot,
       xm_abc, xm_xyz,
       xm_invert, xm_surfparams, xm_color,
       xm_rot123, xm_ctbl) = m
  in
  m_tex
in

(* ���̂̌`�� 0:������ 1:���� 2:�񎟋Ȗ� 3:�~�� *)
let rec o_form m =
  let (xm_tex, m_shape, xm_surface, xm_isrot,
       xm_abc, xm_xyz,
       xm_invert, xm_surfparams, xm_color,
       xm_rot123, xm_ctbl) = m
  in
  m_shape
in

(* ���˓��� 0:�g�U���˂̂� 1:�g�U�{�񊮑S���ʔ��� 2:�g�U�{���S���ʔ��� *)
let rec o_reflectiontype m =
  let (xm_tex, xm_shape, m_surface, xm_isrot,
       xm_abc, xm_xyz,
       xm_invert, xm_surfparams, xm_color,
       xm_rot123, xm_ctbl) = m
  in
  m_surface
in

(* �Ȗʂ̊O�����^���ǂ����̃t���O true:�O�����^ false:�������^ *)
let rec o_isinvert m =
  let (xm_tex, xm_shape, xm_surface, xm_isrot,
       xm_abc, xm_xyz,
       m_invert, xm_surfparams, xm_color,
       xm_rot123, xm_ctbl) = m in
  m_invert
in

(* ��]�̗L�� true:��]���� false:��]���� 2���ȖʂƉ~���̂ݗL�� *)
let rec o_isrot m =
  let (xm_tex, xm_shape, xm_surface, m_isrot,
       xm_abc, xm_xyz,
       xm_invert, xm_surfparams, xm_color,
       xm_rot123, xm_ctbl) = m in
  m_isrot
in

(* ���̌`��� a�p�����[�^ *)
let rec o_param_a m =
  let (xm_tex, xm_shape, xm_surface, xm_isrot,
       m_abc, xm_xyz,
       xm_invert, xm_surfparams, xm_color,
       xm_rot123, xm_ctbl) = m
  in
  m_abc.(0)
in

(* ���̌`��� b�p�����[�^ *)
let rec o_param_b m =
  let (xm_tex, xm_shape, xm_surface, xm_isrot,
       m_abc, xm_xyz,
       xm_invert, xm_surfparams, xm_color,
       xm_rot123, xm_ctbl) = m
  in
  m_abc.(1)
in

(* ���̌`��� c�p�����[�^ *)
let rec o_param_c m =
  let (xm_tex, xm_shape, xm_surface, xm_isrot,
       m_abc, xm_xyz,
       xm_invert, xm_surfparams, xm_color,
       xm_rot123, xm_ctbl) = m
  in
  m_abc.(2)
in

(* ���̌`��� abc�p�����[�^ *)
let rec o_param_abc m =
  let (xm_tex, xm_shape, xm_surface, xm_isrot,
       m_abc, xm_xyz,
       xm_invert, xm_surfparams, xm_color,
       xm_rot123, xm_ctbl) = m
  in
  m_abc
in

(* ���̂̒��Sx���W *)
let rec o_param_x m =
  let (xm_tex, xm_shape, xm_surface, xm_isrot,
       xm_abc, m_xyz,
       xm_invert, xm_surfparams, xm_color,
       xm_rot123, xm_ctbl) = m
  in
  m_xyz.(0)
in

(* ���̂̒��Sy���W *)
let rec o_param_y m =
  let (xm_tex, xm_shape, xm_surface, xm_isrot,
       xm_abc, m_xyz,
       xm_invert, xm_surfparams, xm_color,
       xm_rot123, xm_ctbl) = m
  in
  m_xyz.(1)
in

(* ���̂̒��Sz���W *)
let rec o_param_z m =
  let (xm_tex, xm_shape, xm_surface, xm_isrot,
       xm_abc, m_xyz,
       xm_invert, xm_surfparams, xm_color,
       xm_rot123, xm_ctbl) = m
  in
  m_xyz.(2)
in

(* ���̂̊g�U���˗� 0.0 -- 1.0 *)
let rec o_diffuse m =
  let (xm_tex, xm_shape, xm_surface, xm_isrot,
       xm_abc, xm_xyz,
       xm_invert, m_surfparams, xm_color,
       xm_rot123, xm_ctbl) = m
  in
  m_surfparams.(0)
in

(* ���̂̕s���S���ʔ��˗� 0.0 -- 1.0 *)
let rec o_hilight m =
  let (xm_tex, xm_shape, xm_surface, xm_isrot,
       xm_abc, xm_xyz,
       xm_invert, m_surfparams, xm_color,
       xm_rot123, xm_ctbl) = m
  in
  m_surfparams.(1)
in

(* ���̐F�� R���� *)
let rec o_color_red m =
  let (xm_tex, xm_shape, m_surface, xm_isrot,
       xm_abc, xm_xyz,
       xm_invert, xm_surfparams, m_color,
       xm_rot123, xm_ctbl) = m
  in
  m_color.(0)
in

(* ���̐F�� G���� *)
let rec o_color_green m =
  let (xm_tex, xm_shape, m_surface, xm_isrot,
       xm_abc, xm_xyz,
       xm_invert, xm_surfparams, m_color,
       xm_rot123, xm_ctbl) = m
  in
  m_color.(1)
in

(* ���̐F�� B���� *)
let rec o_color_blue m =
  let (xm_tex, xm_shape, m_surface, xm_isrot,
       xm_abc, xm_xyz,
       xm_invert, xm_surfparams, m_color,
       xm_rot123, xm_ctbl) = m
  in
  m_color.(2)
in

(* ���̂̋Ȗʕ������� y*z���̌W�� 2���ȖʂƉ~���ŁA��]������ꍇ�̂� *)
let rec o_param_r1 m =
  let (xm_tex, xm_shape, xm_surface, xm_isrot,
       xm_abc, xm_xyz,
       xm_invert, xm_surfparams, xm_color,
       m_rot123, xm_ctbl) = m
  in
  m_rot123.(0)
in

(* ���̂̋Ȗʕ������� x*z���̌W�� 2���ȖʂƉ~���ŁA��]������ꍇ�̂� *)
let rec o_param_r2 m =
  let (xm_tex, xm_shape, xm_surface, xm_isrot,
       xm_abc, xm_xyz,
       xm_invert, xm_surfparams, xm_color,
       m_rot123, xm_ctbl) = m
  in
  m_rot123.(1)
in

(* ���̂̋Ȗʕ������� x*y���̌W�� 2���ȖʂƉ~���ŁA��]������ꍇ�̂� *)
let rec o_param_r3 m =
  let (xm_tex, xm_shape, xm_surface, xm_isrot,
       xm_abc, xm_xyz,
       xm_invert, xm_surfparams, xm_color,
       m_rot123, xm_ctbl) = m
  in
  m_rot123.(2)
in

(* �����̔��˓_�����炩���ߌv�Z�����ꍇ�̒萔�e�[�u�� *)
(*
   0 -- 2 �Ԗڂ̗v�f: ���̂̌ŗL���W�n�ɕ��s�ړ����������n�_
   3�Ԗڂ̗v�f:
   �����́�����
   ���ʁ� abc�x�N�g���Ƃ̓���
   �񎟋ȖʁA�~�����񎟕������̒萔��
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
   Pixel�f�[�^�̃����o�A�N�Z�X�֐��Q
 *****************************************************************************)

(* ���ڌ��ǐՂœ���ꂽ�s�N�Z����RGB�l *)
let rec p_rgb pixel =
  let (m_rgb, xm_isect_ps, xm_sids, xm_cdif, xm_engy,
       xm_r20p, xm_gid, xm_nvectors ) = pixel in
  m_rgb
in

(* ��΂����������̂ƏՓ˂����_�̔z�� *)
let rec p_intersection_points pixel =
  let (xm_rgb, m_isect_ps, xm_sids, xm_cdif, xm_engy,
       xm_r20p, xm_gid, xm_nvectors ) = pixel in
  m_isect_ps
in

(* ��΂��������Փ˂������̖ʔԍ��̔z�� *)
(* ���̖ʔԍ��� �I�u�W�F�N�g�ԍ� * 4 + (solver�̕Ԃ�l) *)
let rec p_surface_ids pixel =
  let (xm_rgb, xm_isect_ps, m_sids, xm_cdif, xm_engy,
       xm_r20p, xm_gid, xm_nvectors ) = pixel in
  m_sids
in

(* �Ԑڎ�����v�Z���邩�ۂ��̃t���O *)
let rec p_calc_diffuse pixel =
  let (xm_rgb, xm_isect_ps, xm_sids, m_cdif, xm_engy,
       xm_r20p, xm_gid, xm_nvectors ) = pixel in
  m_cdif
in

(* �Փ˓_�̊Ԑڎ���G�l���M�[���s�N�Z���P�x�ɗ^�����^�̑傫�� *)
let rec p_energy pixel =
  let (xm_rgb, xm_isect_ps, xm_sids, xm_cdif, m_engy,
       xm_r20p, xm_gid, xm_nvectors ) = pixel in
  m_engy
in

(* �Փ˓_�̊Ԑڎ���G�l���M�[�������{����1/5�ɊԈ������Čv�Z�����l *)
let rec p_received_ray_20percent pixel =
  let (xm_rgb, xm_isect_ps, xm_sids, xm_cdif, xm_engy,
       m_r20p, xm_gid, xm_nvectors ) = pixel in
  m_r20p
in

(* ���̃s�N�Z���̃O���[�v ID *)
(*
   �X�N���[�����W (x,y)�̓_�̃O���[�vID�� (x+2*y) mod 5 �ƒ�߂�
   ���ʁA���}�̂悤�ȕ������ɂȂ�A�e�_�͏㉺���E4�_�ƕʂȃO���[�v�ɂȂ�
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

(* �O���[�vID���Z�b�g����A�N�Z�X�֐� *)
let rec p_set_group_id pixel id =
  let (xm_rgb, xm_isect_ps, xm_sids, xm_cdif, xm_engy,
       xm_r20p, m_gid, xm_nvectors ) = pixel in
  m_gid.(0) <- id
in

(* �e�Փ˓_�ɂ�����@���x�N�g�� *)
let rec p_nvectors pixel =
  let (xm_rgb, xm_isect_ps, xm_sids, xm_cdif, xm_engy,
       xm_r20p, xm_gid, m_nvectors ) = pixel in
  m_nvectors
in

(******************************************************************************
   �O�����ςݕ����x�N�g���̃����o�A�N�Z�X�֐�
 *****************************************************************************)

(* �x�N�g�� *)
let rec d_vec d =
  let (m_vec, xm_const) = d in
  m_vec
in

(* �e�I�u�W�F�N�g�ɑ΂��č���� solver �������p�萔�e�[�u�� *)
let rec d_const d =
  let (dm_vec, m_const) = d in
  m_const
in

(******************************************************************************
   ���ʋ��ʑ̂̔��ˏ��
 *****************************************************************************)

(* �ʔԍ� �I�u�W�F�N�g�ԍ�*4 + (solver�̕Ԃ�l) *)
let rec r_surface_id r =
  let (m_sid, xm_dvec, xm_br) = r in
  m_sid
in

(* �������̔��˕����x�N�g��(���Ƌt����) *)
let rec r_dvec r =
  let (xm_sid, m_dvec, xm_br) = r in
  m_dvec
in

(* ���̂̔��˗� *)
let rec r_bright r =
  let (xm_sid, xm_dvec, m_br) = r in
  m_br
in

(******************************************************************************
   �f�[�^�ǂݍ��݂̊֐��Q
 *****************************************************************************)

(* ���W�A�� *)
let rec rad x =
  x *. 0.017453293
in

(**** ���f�[�^�̓ǂݍ��� ****)
let rec read_screen_settings _ =

  (* �X�N���[�����S�̍��W *)
  screen.(0) <- read_float ();
  screen.(1) <- read_float ();
  screen.(2) <- read_float ();
  (* ��]�p *)
  let v1 = rad (read_float ()) in
  let cos_v1 = cos v1 in
  let sin_v1 = sin v1 in
  let v2 = rad (read_float ()) in
  let cos_v2 = cos v2 in
  let sin_v2 = sin v2 in
  (* �X�N���[���ʂ̉��s�������̃x�N�g�� �����_����̋���200�������� *)
  screenz_dir.(0) <- cos_v1 *. sin_v2 *. 200.0;
  screenz_dir.(1) <- sin_v1 *. -200.0;
  screenz_dir.(2) <- cos_v1 *. cos_v2 *. 200.0;
  (* �X�N���[����X�����̃x�N�g�� *)
  screenx_dir.(0) <- cos_v2;
  screenx_dir.(1) <- 0.0;
  screenx_dir.(2) <- fneg sin_v2;
  (* �X�N���[����Y�����̃x�N�g�� *)
  screeny_dir.(0) <- fneg sin_v1 *. sin_v2;
  screeny_dir.(1) <- fneg cos_v1;
  screeny_dir.(2) <- fneg sin_v1 *. cos_v2;
  (* ���_�ʒu�x�N�g��(��΍��W) *)
  viewpoint.(0) <- screen.(0) -. screenz_dir.(0);
  viewpoint.(1) <- screen.(1) -. screenz_dir.(1);
  viewpoint.(2) <- screen.(2) -. screenz_dir.(2)

in

(* �������̓ǂݍ��� *)
let rec read_light _ =

  let nl = read_int () in

  (* �����֌W *)
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

(* ����2���`���s�� A �ɗ��������]�s�� R ���������s�� R^t * A * R ����� *)
(* R �� x,y,z���Ɋւ����]�s��̐� R(z)R(y)R(x) *)
(* �X�N���[�����W�̂��߁Ay����]�̂݊p�x�̕������t *)

let rec rotate_quadratic_matrix abc rot =
  (* ��]�s��̐� R(z)R(y)R(x) ���v�Z���� *)
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

  (* a, b, c�̌��̒l���o�b�N�A�b�v *)
  let ao = abc.(0) in
  let bo = abc.(1) in
  let co = abc.(2) in

  (* R^t * A * R ���v�Z *)

  (* X^2, Y^2, Z^2���� *)
  abc.(0) <- ao *. fsqr m00 +. bo *. fsqr m10 +. co *. fsqr m20;
  abc.(1) <- ao *. fsqr m01 +. bo *. fsqr m11 +. co *. fsqr m21;
  abc.(2) <- ao *. fsqr m02 +. bo *. fsqr m12 +. co *. fsqr m22;

  (* ��]�ɂ���Đ����� XY, YZ, ZX���� *)
  rot.(0) <- 2.0 *. (ao *. m01 *. m02 +. bo *. m11 *. m12 +. co *. m21 *. m22);
  rot.(1) <- 2.0 *. (ao *. m00 *. m02 +. bo *. m10 *. m12 +. co *. m20 *. m22);
  rot.(2) <- 2.0 *. (ao *. m00 *. m01 +. bo *. m10 *. m11 +. co *. m20 *. m21)

in

(**** �I�u�W�F�N�g1�̃f�[�^�̓ǂݍ��� ****)
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

      (* �p�����[�^�̐��K�� *)

      (* ��: ���L���K�� (form = 2) �Q�� *)
      let m_invert2 = if form = 2 then true else m_invert in
      let ctbl = create_array 4 0.0 in
      (* �������炠�Ƃ� abc �� rotation �������삵�Ȃ��B*)
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
	  (* 2���Ȗ�: X,Y,Z �T�C�Y����2���`���s��̑Ίp������ *)
	 let a = abc.(0) in
	 abc.(0) <- if fiszero a then 0.0 else sgn a /. fsqr a; (* X^2 ���� *)
	 let b = abc.(1) in
	 abc.(1) <- if fiszero b then 0.0 else sgn b /. fsqr b; (* Y^2 ���� *)
	 let c = abc.(2) in
	 abc.(2) <- if fiszero c then 0.0 else sgn c /. fsqr c  (* Z^2 ���� *)
	)
      else if form = 2 then
	(* ����: �@���x�N�g���𐳋K��, �ɐ��𕉂ɓ��� *)
	vecunit_sgn abc (not m_invert)
      else ();

      (* 2���`���s��ɉ�]�ϊ����{�� *)
      if isrot_p <> 0 then
	rotate_quadratic_matrix abc rotation
      else ();

      true
     )
  else
    false (* �f�[�^�̏I�� *)
in

(**** ���̃f�[�^�S�̂̓ǂݍ��� ****)
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

(**** AND, OR �l�b�g���[�N�̓ǂݍ��� ****)

(* �l�b�g���[�N1��ǂݍ��݃x�N�g���ɂ��ĕԂ� *)
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
   �����ƃI�u�W�F�N�g�̌�_�����߂�֐��Q
 *****************************************************************************)

(* solver :
   �I�u�W�F�N�g (�� index) �ƁA�x�N�g�� L, P ���󂯂Ƃ�A
   ���� Lt + P �ƁA�I�u�W�F�N�g�Ƃ̌�_�����߂�B
   ��_���Ȃ��ꍇ�� 0 ���A��_������ꍇ�͂���ȊO��Ԃ��B
   ���̕Ԃ�l�� nvector �Ō�_�̖@���x�N�g�������߂�ۂɕK�v�B
   (�����̂̏ꍇ)
   ��_�̍��W�� t �̒l�Ƃ��� solver_dist �Ɋi�[�����B
*)

(* �����̂̎w�肳�ꂽ�ʂɏՓ˂��邩�ǂ������肷�� *)
(* i0 : �ʂɐ����Ȏ���index X:0, Y:1, Z:2         i2,i3�͑���2����index *)
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


(***** �����̃I�u�W�F�N�g�̏ꍇ ****)
let rec solver_rect m dirvec b0 b1 b2 =
  if      solver_rect_surface m dirvec b0 b1 b2 0 1 2 then 1   (* YZ ���� *)
  else if solver_rect_surface m dirvec b1 b2 b0 1 2 0 then 2   (* ZX ���� *)
  else if solver_rect_surface m dirvec b2 b0 b1 2 0 1 then 3   (* XY ���� *)
  else                                                     0
in


(* ���ʃI�u�W�F�N�g�̏ꍇ *)
let rec solver_surface m dirvec b0 b1 b2 =
  (* �_�ƕ��ʂ̕��������� *)
  (* ���ʂ͋ɐ������ɓ��ꂳ��Ă��� *)
  let abc = o_param_abc m in
  let d = veciprod dirvec abc in
  if fispos d then (
    solver_dist.(0) <- fneg (veciprod2 abc b0 b1 b2) /. d;
    1
   ) else 0
in


(* 3�ϐ�2���`�� v^t A v ���v�Z *)
(* ��]�������ꍇ�͑Ίp�����̂݌v�Z����Ηǂ� *)
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

(* 3�ϐ��o1���`�� v^t A w ���v�Z *)
(* ��]�������ꍇ�� A �̑Ίp�����̂݌v�Z����Ηǂ� *)
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


(* 2���Ȗʂ܂��͉~���̏ꍇ *)
(* 2���`���ŕ\�����ꂽ�Ȗ� x^t A x - (0 �� 1) = 0 �� ���� base + dirvec*t ��
   ��_�����߂�B�Ȑ��̕������� x = base + dirvec*t ��������t�����߂�B
   �܂� (base + dirvec*t)^t A (base + dirvec*t) - (0 �� 1) = 0�A
   �W�J����� (dirvec^t A dirvec)*t^2 + 2*(dirvec^t A base)*t  +
   (base^t A base) - (0��1) = 0 �A�����t�Ɋւ���2���������������Ηǂ��B*)

let rec solver_second m dirvec b0 b1 b2 =

  (* ���̌��� (-b' �} sqrt(b'^2 - a*c)) / a  ���g�p(b' = b/2) *)
  (* a = dirvec^t A dirvec *)
  let aa = quadratic m dirvec.(0) dirvec.(1) dirvec.(2) in

  if fiszero aa then
    0 (* ���m�ɂ͂��̏ꍇ��1���������̉������邪�A�������Ă��ʏ�͑��v *)
  else (

    (* b' = b/2 = dirvec^t A base   *)
    let bb = bilinear m dirvec.(0) dirvec.(1) dirvec.(2) b0 b1 b2 in
    (* c = base^t A base  - (0��1)  *)
    let cc0 = quadratic m b0 b1 b2 in
    let cc = if o_form m = 3 then cc0 -. 1.0 else cc0 in
    (* ���ʎ� *)
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

(**** solver �̃��C�����[�`�� ****)
let rec solver index dirvec org =
  let m = objects.(index) in
  (* �����̎n�_�𕨑̂̊�ʒu�ɍ��킹�ĕ��s�ړ� *)
  let b0 =  org.(0) -. o_param_x m in
  let b1 =  org.(1) -. o_param_y m in
  let b2 =  org.(2) -. o_param_z m in
  let m_shape = o_form m in
  (* ���̂̎�ނɉ������⏕�֐����Ă� *)
  if m_shape = 1 then       solver_rect m dirvec b0 b1 b2    (* ������ *)
  else if m_shape = 2 then  solver_surface m dirvec b0 b1 b2 (* ���� *)
  else                      solver_second m dirvec b0 b1 b2  (* 2���Ȗ�/�~�� *)
in

(******************************************************************************
   solver�̃e�[�u���g�p������
 *****************************************************************************)
(*
   �ʏ��solver �Ɠ��l�A���� start + t * dirvec �ƕ��̂̌�_�� t �̒l�Ƃ��ĕԂ�
   t �̒l�� solver_dist�Ɋi�[

   solver_fast �́A�����̕����x�N�g�� dirvec �ɂ��č�����e�[�u�����g�p
   �����I�� solver_rect_fast, solver_surface_fast, solver_second_fast���Ă�

   solver_fast2 �́Adirvec�ƒ����̎n�_ start ���ꂼ��ɍ�����e�[�u�����g�p
   �����̂ɂ��Ă�start�̃e�[�u���ɂ�鍂�����͂ł��Ȃ��̂ŁAsolver_fast��
   ������ solver_rect_fast������I�ɌĂԁB����ȊO�̕��̂ɂ��Ă�
   solver_surface_fast2�܂���solver_second_fast2������I�ɌĂ�
   �ϐ�dconst�͕����x�N�g���Asconst�͎n�_�Ɋւ���e�[�u��
*)

(***** solver_rect��dirvec�e�[�u���g�p������ ******)
let rec solver_rect_fast m v dconst b0 b1 b2 =
  let d0 = (dconst.(0) -. b0) *. dconst.(1) in
  if  (* YZ���ʂƂ̏Փ˔��� *)
    if fless (fabs (d0 *. v.(1) +. b1)) (o_param_b m) then
      if fless (fabs (d0 *. v.(2) +. b2)) (o_param_c m) then
	not (fiszero dconst.(1))
      else false
    else false
  then
    (solver_dist.(0) <- d0; 1)
  else let d1 = (dconst.(2) -. b1) *. dconst.(3) in
  if  (* ZX���ʂƂ̏Փ˔��� *)
    if fless (fabs (d1 *. v.(0) +. b0)) (o_param_a m) then
      if fless (fabs (d1 *. v.(2) +. b2)) (o_param_c m) then
	not (fiszero dconst.(3))
      else false
    else false
  then
    (solver_dist.(0) <- d1; 2)
  else let d2 = (dconst.(4) -. b2) *. dconst.(5) in
  if  (* XY���ʂƂ̏Փ˔��� *)
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

(**** solver_surface��dirvec�e�[�u���g�p������ ******)
let rec solver_surface_fast m dconst b0 b1 b2 =
  if fisneg dconst.(0) then (
    solver_dist.(0) <-
      dconst.(1) *. b0 +. dconst.(2) *. b1 +. dconst.(3) *. b2;
    1
   ) else 0
in

(**** solver_second ��dirvec�e�[�u���g�p������ ******)
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

(**** solver ��dirvec�e�[�u���g�p������ *******)
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




(* solver_surface��dirvec+start�e�[�u���g�p������ *)
let rec solver_surface_fast2 m dconst sconst b0 b1 b2 =
  if fisneg dconst.(0) then (
    solver_dist.(0) <- dconst.(0) *. sconst.(3);
    1
   ) else 0
in

(* solver_second��dirvec+start�e�[�u���g�p������ *)
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

(* solver�́Adirvec+start�e�[�u���g�p������ *)
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
   �����x�N�g���̒萔�e�[�u�����v�Z����֐��Q
 *****************************************************************************)

(* �����̃I�u�W�F�N�g�ɑ΂���O���� *)
let rec setup_rect_table vec m =
  let const = create_array 6 0.0 in

  if fiszero vec.(0) then (* YZ���� *)
    const.(1) <- 0.0
  else (
    (* �ʂ� X ���W *)
    const.(0) <- fneg_cond (xor (o_isinvert m) (fisneg vec.(0))) (o_param_a m);
    (* �����x�N�g�������{�����X������1�i�ނ� *)
    const.(1) <- 1.0 /. vec.(0)
  );
  if fiszero vec.(1) then (* ZX���� : YZ���ʂƓ��l*)
    const.(3) <- 0.0
  else (
    const.(2) <- fneg_cond (xor (o_isinvert m) (fisneg vec.(1))) (o_param_b m);
    const.(3) <- 1.0 /. vec.(1)
  );
  if fiszero vec.(2) then (* XY���� : YZ���ʂƓ��l*)
    const.(5) <- 0.0
  else (
    const.(4) <- fneg_cond (xor (o_isinvert m) (fisneg vec.(2))) (o_param_c m);
    const.(5) <- 1.0 /. vec.(2)
  );
  const
in

(* ���ʃI�u�W�F�N�g�ɑ΂���O���� *)
let rec setup_surface_table vec m =
  let const = create_array 4 0.0 in
  let d =
    vec.(0) *. o_param_a m +. vec.(1) *. o_param_b m +. vec.(2) *. o_param_c m
  in
  if fispos d then (
    (* �����x�N�g�������{����Ε��ʂ̐��������� 1 �i�ނ� *)
    const.(0) <- -1.0 /. d;
    (* ����_�̕��ʂ���̋����������x�N�g���������𓱂�3����`���̌W�� *)
    const.(1) <- fneg (o_param_a m /. d);
    const.(2) <- fneg (o_param_b m /. d);
    const.(3) <- fneg (o_param_c m /. d)
   ) else
    const.(0) <- 0.0;
  const

in

(* 2���Ȗʂɑ΂���O���� *)
let rec setup_second_table v m =
  let const = create_array 5 0.0 in

  let aa = quadratic m v.(0) v.(1) v.(2) in
  let c1 = fneg (v.(0) *. o_param_a m) in
  let c2 = fneg (v.(1) *. o_param_b m) in
  let c3 = fneg (v.(2) *. o_param_c m) in

  const.(0) <- aa;  (* 2���������� a �W�� *)

  (* b' = dirvec^t A start �����A(dirvec^t A)�̕������v�Z��const.(1:3)�Ɋi�[�B
     b' �����߂�ɂ͂��̃x�N�g����start�̓��ς����Ηǂ��B�����͋t�ɂ��� *)
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
    const.(4) <- 1.0 /. aa (* a�W���̋t�������߁A���̌����ł̊���Z������ *)
  else ();
  const

in

(* �e�I�u�W�F�N�g�ɂ��ĕ⏕�֐����Ă�Ńe�[�u������� *)
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
   �����̎n�_�Ɋւ���e�[�u�����e�I�u�W�F�N�g�ɑ΂��Čv�Z����֐��Q
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
   �^����ꂽ�_���I�u�W�F�N�g�Ɋ܂܂�邩�ǂ����𔻒肷��֐��Q
 *****************************************************************************)

(**** �_ q ���I�u�W�F�N�g m �̊O�����ǂ����𔻒肷�� ****)

(* ������ *)
let rec is_rect_outside m p0 p1 p2 =
  if
    if (fless (fabs p0) (o_param_a m)) then
      if (fless (fabs p1) (o_param_b m)) then
	fless (fabs p2) (o_param_c m)
      else false
    else false
  then o_isinvert m else not (o_isinvert m)
in

(* ���� *)
let rec is_plane_outside m p0 p1 p2 =
  let w = veciprod2 (o_param_abc m) p0 p1 p2 in
  not (xor (o_isinvert m) (fisneg w))
in

(* 2���Ȗ� *)
let rec is_second_outside m p0 p1 p2 =
  let w = quadratic m p0 p1 p2 in
  let w2 = if o_form m = 3 then w -. 1.0 else w in
  not (xor (o_isinvert m) (fisneg w2))
in

(* ���̂̒��S���W�ɕ��s�ړ�������ŁA�K�؂ȕ⏕�֐����Ă� *)
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

(**** �_ q �� AND �l�b�g���[�N iand �̓����ɂ��邩�ǂ����𔻒� ****)
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
   �Փ˓_�����̕��̂̉e�ɓ����Ă��邩�ۂ��𔻒肷��֐��Q
 *****************************************************************************)

(* �_ intersection_point ����A�����x�N�g���̕����ɒH��A   *)
(* ���̂ɂԂ��� (=�e�ɂ͂����Ă���) ���ۂ��𔻒肷��B*)

(**** AND �l�b�g���[�N iand �̉e�����ǂ����̔��� ****)
let rec shadow_check_and_group iand_ofs and_group =
  if and_group.(iand_ofs) = -1 then
    false
  else
    let obj = and_group.(iand_ofs) in
    let t0 = solver_fast obj light_dirvec intersection_point in
    let t0p = solver_dist.(0) in
    if (if t0 <> 0 then fless t0p (-0.2) else false) then
      (* Q: ��_�̌��B���ۂɂ��ׂẴI�u�W�F�N�g�� *)
      (* �����Ă��邩�ǂ����𒲂ׂ�B*)
      let t = t0p +. 0.01 in
      let q0 = light.(0) *. t +. intersection_point.(0) in
      let q1 = light.(1) *. t +. intersection_point.(1) in
      let q2 = light.(2) *. t +. intersection_point.(2) in
      if check_all_inside 0 and_group q0 q1 q2 then
	true
      else
	shadow_check_and_group (iand_ofs + 1) and_group
	  (* ���̃I�u�W�F�N�g������_��T�� *)
    else
      (* ��_���Ȃ��ꍇ: �ɐ�����(�������^)�̏ꍇ�A    *)
      (* AND �l�b�g�̋��ʕ����͂��̓����Ɋ܂܂�邽�߁A*)
      (* ��_�͂Ȃ����Ƃ͎����B�T����ł��؂�B        *)
      if o_isinvert (objects.(obj)) then
	shadow_check_and_group (iand_ofs + 1) and_group
      else
	false
in

(**** OR �O���[�v or_group �̉e���ǂ����̔��� ****)
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

(**** OR �O���[�v�̗�̂ǂꂩ�̉e�ɓ����Ă��邩�ǂ����̔��� ****)
let rec shadow_check_one_or_matrix ofs or_matrix =
  let head = or_matrix.(ofs) in
  let range_primitive = head.(0) in
  if range_primitive = -1 then (* OR�s��̏I���}�[�N *)
    false
  else
    if (* range primitive ���������A�܂���range_primitive�ƌ���鎖���m�F *)
      if range_primitive = 99 then      (* range primitive ������ *)
	true
      else              (* range_primitive������ *)
	let t = solver_fast range_primitive light_dirvec intersection_point in
        (* range primitive �ƂԂ���Ȃ���� *)
        (* or group �Ƃ̌�_�͂Ȃ�            *)
	if t <> 0 then
          if fless solver_dist.(0) (-0.1) then
            if shadow_check_one_or_group 1 head then
              true
	    else false
	  else false
	else false
    then
      if (shadow_check_one_or_group 1 head) then
	true (* ��_������̂ŁA�e�ɓ��鎖�������B�T���I�� *)
      else
	shadow_check_one_or_matrix (ofs + 1) or_matrix (* ���̗v�f������ *)
    else
      shadow_check_one_or_matrix (ofs + 1) or_matrix (* ���̗v�f������ *)

in

(******************************************************************************
   �����ƕ��̂̌�������
 *****************************************************************************)

(**** ����AND�l�b�g���[�N���A���C�g���[�X�̕����ɑ΂��A****)
(**** ��_�����邩�ǂ����𒲂ׂ�B                     ****)
let rec solve_each_element iand_ofs and_group dirvec =
  let iobj = and_group.(iand_ofs) in
  if iobj = -1 then ()
  else (
    let t0 = solver iobj dirvec startp in
    if t0 <> 0 then
      (
       (* ��_�����鎞�́A���̌�_�����̗v�f�̒��Ɋ܂܂�邩�ǂ������ׂ�B*)
       (* ���܂ł̒��ōŏ��� t �̒l�Ɣ�ׂ�B*)
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
      (* ��_���Ȃ��A���������̕��͓̂������^�Ȃ炱��ȏ��_�͂Ȃ� *)
      if o_isinvert (objects.(iobj)) then
	solve_each_element (iand_ofs + 1) and_group dirvec
      else ()

   )
in

(**** 1�� OR-group �ɂ��Č�_�𒲂ׂ� ****)
let rec solve_one_or_network ofs or_group dirvec =
  let head = or_group.(ofs) in
  if head <> -1 then (
    let and_group = and_net.(head) in
    solve_each_element 0 and_group dirvec;
    solve_one_or_network (ofs + 1) or_group dirvec
   ) else ()
in

(**** OR�}�g���N�X�S�̂ɂ��Č�_�𒲂ׂ�B****)
let rec trace_or_matrix ofs or_network dirvec =
  let head = or_network.(ofs) in
  let range_primitive = head.(0) in
  if range_primitive = -1 then (* �S�I�u�W�F�N�g�I�� *)
    ()
  else (
    if range_primitive = 99 (* range primitive �Ȃ� *)
    then (solve_one_or_network 1 head dirvec)
    else
      (
	(* range primitive �̏Փ˂��Ȃ���Ό�_�͂Ȃ� *)
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

(**** �g���[�X�{�� ****)
(* �g���[�X�J�n�_ ViewPoint �ƁA���̓_����̃X�L���������x�N�g�� *)
(* Vscan ����A��_ crashed_point �ƏՓ˂����I�u�W�F�N�g         *)
(* crashed_object ��Ԃ��B�֐����̂̕Ԃ�l�͌�_�̗L���̐^�U�l�B *)
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
   �����ƕ��̂̌������� ������
 *****************************************************************************)

let rec solve_each_element_fast iand_ofs and_group dirvec =
  let vec = (d_vec dirvec) in
  let iobj = and_group.(iand_ofs) in
  if iobj = -1 then ()
  else (
    let t0 = solver_fast2 iobj dirvec in
    if t0 <> 0 then
      (
        (* ��_�����鎞�́A���̌�_�����̗v�f�̒��Ɋ܂܂�邩�ǂ������ׂ�B*)
        (* ���܂ł̒��ōŏ��� t �̒l�Ɣ�ׂ�B*)
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
       (* ��_���Ȃ��A���������̕��͓̂������^�Ȃ炱��ȏ��_�͂Ȃ� *)
       if o_isinvert (objects.(iobj)) then
	 solve_each_element_fast (iand_ofs + 1) and_group dirvec
       else ()
   )
in

(**** 1�� OR-group �ɂ��Č�_�𒲂ׂ� ****)
let rec solve_one_or_network_fast ofs or_group dirvec =
  let head = or_group.(ofs) in
  if head <> -1 then (
    let and_group = and_net.(head) in
    solve_each_element_fast 0 and_group dirvec;
    solve_one_or_network_fast (ofs + 1) or_group dirvec
   ) else ()
in

(**** OR�}�g���N�X�S�̂ɂ��Č�_�𒲂ׂ�B****)
let rec trace_or_matrix_fast ofs or_network dirvec =
  let head = or_network.(ofs) in
  let range_primitive = head.(0) in
  if range_primitive = -1 then (* �S�I�u�W�F�N�g�I�� *)
    ()
  else (
    if range_primitive = 99 (* range primitive �Ȃ� *)
    then solve_one_or_network_fast 1 head dirvec
    else
      (
	(* range primitive �̏Փ˂��Ȃ���Ό�_�͂Ȃ� *)
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

(**** �g���[�X�{�� ****)
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
   ���̂ƌ��̌����_�̖@���x�N�g�������߂�֐�
 *****************************************************************************)

(**** ��_����@���x�N�g�����v�Z���� ****)
(* �Փ˂����I�u�W�F�N�g�����߂��ۂ� solver �̕Ԃ�l�� *)
(* �ϐ� intsec_rectside �o�R�œn���Ă��K�v������B  *)
(* nvector ���O���[�o���B *)

let rec get_nvector_rect dirvec =
  let rectside = intsec_rectside.(0) in
  (* solver �̕Ԃ�l�͂Ԃ������ʂ̕��������� *)
  vecbzero nvector;
  nvector.(rectside-1) <- fneg (sgn (dirvec.(rectside-1)))
in

(* ���� *)
let rec get_nvector_plane m =
  (* m_invert �͏�� true �̂͂� *)
  nvector.(0) <- fneg (o_param_a m); (* if m_invert then fneg m_a else m_a *)
  nvector.(1) <- fneg (o_param_b m);
  nvector.(2) <- fneg (o_param_c m)
in

(* 2���Ȗ� :  grad x^t A x = 2 A x �𐳋K������ *)
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
  else (* 2���Ȗ� or ���� *)
    get_nvector_second m
  (* retval = nvector *)
in

(******************************************************************************
   ���̕\�ʂ̐F(�F�t���g�U���˗�)�����߂�
 *****************************************************************************)

(**** ��_��̃e�N�X�`���̐F���v�Z���� ****)
let rec utexture m p =
  let m_tex = o_texturetype m in
  (* ��{�̓I�u�W�F�N�g�̐F *)
  texture_color.(0) <- o_color_red m;
  texture_color.(1) <- o_color_green m;
  texture_color.(2) <- o_color_blue m;
  if m_tex = 1 then
    (
     (* zx�����̃`�F�b�J�[�͗l (G) *)
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
    (* y�������̃X�g���C�v (R-G) *)
    (
      let w2 = fsqr (sin (p.(1) *. 0.25)) in
      texture_color.(0) <- 255.0 *. w2;
      texture_color.(1) <- 255.0 *. (1.0 -. w2)
    )
  else if m_tex = 3 then
    (* ZX�ʕ����̓��S�~ (G-B) *)
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
    (* ���ʏ�̔��_ (B) *)
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
   �Փ˓_�ɓ���������̒��ڌ��Ɣ��ˌ����v�Z����֐��Q
 *****************************************************************************)

(* �����������ɂ��g�U���ƕs���S���ʔ��ˌ��ɂ���^��RGB�l�ɉ��Z *)
let rec add_light bright hilight hilight_scale =

  (* �g�U�� *)
  if fispos bright then
    vecaccum rgb bright texture_color
  else ();

  (* �s���S���ʔ��� cos ^4 ���f�� *)
  if fispos hilight then (
    let ihl = fsqr (fsqr hilight) *. hilight_scale in
    rgb.(0) <- rgb.(0) +. ihl;
    rgb.(1) <- rgb.(1) +. ihl;
    rgb.(2) <- rgb.(2) +. ihl
  ) else ()
in

(* �e���̂ɂ������̔��ˌ����v�Z����֐�(�����̂ƕ��ʂ̂�) *)
let rec trace_reflections index diffuse hilight_scale dirvec =

  if index >= 0 then (
    let rinfo = reflections.(index) in (* �����ʂ̔��ˏ�� *)
    let dvec = r_dvec rinfo in    (* ���ˌ��̕����x�N�g��(���Ƌt���� *)

    (*���ˌ����t�ɂ��ǂ�A���ۂɂ��̋��ʂɓ�����΁A���ˌ����͂��\���L�� *)
    if judge_intersection_fast dvec then
      let surface_id = intersected_object_id.(0) * 4 + intsec_rectside.(0) in
      if surface_id = r_surface_id rinfo then
	(* ���ʂƂ̏Փ˓_�������̉e�ɂȂ��Ă��Ȃ���Δ��ˌ��͓͂� *)
        if not (shadow_check_one_or_matrix 0 or_net.(0)) then
	  (* �͂������ˌ��ɂ�� RGB�����ւ̊�^�����Z *)
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
   ���ڌ���ǐՂ���
 *****************************************************************************)
let rec trace_ray nref energy dirvec pixel dist =
  if nref <= 4 then (
    let surface_ids = p_surface_ids pixel in
    if judge_intersection dirvec then (
    (* �I�u�W�F�N�g�ɂԂ������ꍇ *)
      let obj_id = intersected_object_id.(0) in
      let obj = objects.(obj_id) in
      let m_surface = o_reflectiontype obj in
      let diffuse = o_diffuse obj *. energy in

      get_nvector obj dirvec; (* �@���x�N�g���� get *)
      veccpy startp intersection_point;  (* �����_��V���Ȍ��̔��˓_�Ƃ��� *)
      utexture obj intersection_point; (*�e�N�X�`�����v�Z *)

      (* pixel tuple�ɏ����i�[���� *)
      surface_ids.(nref) <- obj_id * 4 + intsec_rectside.(0);
      let intersection_points = p_intersection_points pixel in
      veccpy intersection_points.(nref) intersection_point;

      (* �g�U���˗���0.5�ȏ�̏ꍇ�̂݊Ԑڌ��̃T���v�����O���s�� *)
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
      (* ���ˌ��̕����Ƀg���[�X������ύX *)
      vecaccum dirvec w nvector;

      let hilight_scale = energy *. o_hilight obj in

      (* �����������ړ͂��ꍇ�ARGB�����ɂ������������ *)
      if not (shadow_check_one_or_matrix 0 or_net.(0)) then
        let bright = fneg (veciprod nvector light) *. diffuse in
        let hilight = fneg (veciprod dirvec light) in
        add_light bright hilight hilight_scale
      else ();

      (* �������̔��ˌ����������T�� *)
      setup_startp intersection_point;
      trace_reflections (n_reflections.(0)-1) diffuse hilight_scale dirvec;

      (* �d�݂� 0.1��葽���c���Ă�����A���ʔ��ˌ���ǐՂ��� *)
      if fless 0.1 energy then (

	if(nref < 4) then
	  surface_ids.(nref+1) <- -1
	else ();

	if m_surface = 2 then (   (* ���S���ʔ��� *)
	  let energy2 = energy *. (1.0 -. o_diffuse obj) in
	  trace_ray (nref+1) energy2 dirvec pixel (dist +. tmin.(0))
	 ) else ()

	  ) else ()

     ) else (
      (* �ǂ̕��̂ɂ�������Ȃ������ꍇ�B��������̌������� *)

      surface_ids.(nref) <- -1;

      if nref <> 0 then (
	let hl = fneg (veciprod dirvec light) in
        (* 90���𒴂���ꍇ��0 (���Ȃ�) *)
	if fispos hl then
	  (
	   (* �n�C���C�g���x�͊p�x�� cos^3 �ɔ�� *)
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
   �Ԑڌ���ǐՂ���
 *****************************************************************************)

(* ����_������̕�������󂯂�Ԑڌ��̋������v�Z���� *)
(* �Ԑڌ��̕����x�N�g�� dirvec�Ɋւ��Ă͒萔�e�[�u��������Ă���A�Փ˔���
   �������ɍs����B���̂ɓ���������A���̌�̔��˂͒ǐՂ��Ȃ� *)
let rec trace_diffuse_ray dirvec energy =

  (* �ǂꂩ�̕��̂ɓ����邩���ׂ� *)
  if judge_intersection_fast dirvec then
    let obj = objects.(intersected_object_id.(0)) in
    get_nvector obj (d_vec dirvec);
    utexture obj intersection_point;

    (* ���̕��̂����˂�����̋��������߂�B���ڌ������݂̂��v�Z *)
    if not (shadow_check_one_or_matrix 0 or_net.(0)) then
      let br =  fneg (veciprod nvector light) in
      let bright = (if fispos br then br else 0.0) in
      vecaccum diffuse_ray (energy *. bright *. o_diffuse obj) texture_color
    else ()
  else ()
in

(* ���炩���ߌ��߂�ꂽ�����x�N�g���̔z��ɑ΂��A�e�x�N�g���̕��p���痈��
   �Ԑڌ��̋������T���v�����O���ĉ��Z���� *)
let rec iter_trace_diffuse_rays dirvec_group nvector org index =
  if index >= 0 then (
    let p = veciprod (d_vec dirvec_group.(index)) nvector in

    (* �z��� 2n �Ԗڂ� 2n+1 �Ԗڂɂ݂͌��ɋt���̕����x�N�g���������Ă���
       �@���x�N�g���Ɠ��������̕���I��Ŏg�� *)
    if fisneg p then
      trace_diffuse_ray dirvec_group.(index + 1) (p /. -150.0)
    else
      trace_diffuse_ray dirvec_group.(index) (p /. 150.0);

    iter_trace_diffuse_rays dirvec_group nvector org (index - 2)
   ) else ()
in

(* �^����ꂽ�����x�N�g���̏W���ɑ΂��A���̕����̊Ԑڌ����T���v�����O���� *)
let rec trace_diffuse_rays dirvec_group nvector org =
  setup_startp org;
  (* �z��� 2n �Ԗڂ� 2n+1 �Ԗڂɂ݂͌��ɋt���̕����x�N�g���������Ă��āA
     �@���x�N�g���Ɠ��������̕��̂݃T���v�����O�Ɏg���� *)
  (* �S���� 120 / 2 = 60�{�̃x�N�g����ǐ� *)
  iter_trace_diffuse_rays dirvec_group nvector org 118
in

(* ���������̑S����300�{�̃x�N�g���̂����A�܂��ǐՂ��Ă��Ȃ��c���240�{��
   �x�N�g���ɂ��ĊԐڌ��ǐՂ���B60�{�̃x�N�g���ǐՂ�4�Z�b�g�s�� *)
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

(* �㉺���E4�_�̊Ԑڌ��ǐՌ��ʂ��g�킸�A300�{�S���̃x�N�g����ǐՂ��ĊԐڌ���
   �v�Z����B20%(60�{)�͒ǐՍςȂ̂ŁA�c��80%(240�{)��ǐՂ��� *)
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

(* �����Ə㉺���E4�_�̒ǐՌ��ʂ����Z���ĊԐڌ������߂�B�{���� 300 �{�̌���
   �ǐՂ���K�v�����邪�A5�_���Z����̂�1�_������60�{(20%)�ǐՂ��邾���ōς� *)

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

(* �㉺���E4�_���g�킸�ɒ��ڌ��̊e�Փ˓_�ɂ�����Ԑڎ�����v�Z���� *)
let rec do_without_neighbors pixel nref =
  if nref <= 4 then
    (* �Փ˖ʔԍ����L��(��)���`�F�b�N *)
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

(* �摜��ŏ㉺���E�ɓ_�����邩(�v����ɁA�摜�̒[�Ŗ�����)���m�F *)
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

(* �㉺���E4�_�̒��ڌ��ǐՂ̌��ʁA�����Ɠ����ʂɏՓ˂��Ă��邩���`�F�b�N
   ���������ʂɏՓ˂��Ă���΁A�����4�_�̌��ʂ��g�����ƂŌv�Z���ȗ��o���� *)
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

(* ���ڌ��̊e�Փ˓_�ɂ�����Ԑڎ���̋������A�㉺���E4�_�̌��ʂ��g�p���Čv�Z
   ����B�����㉺���E4�_�̌v�Z���ʂ��g���Ȃ��ꍇ�́A���̎��_��
   do_without_neighbors�ɐ؂�ւ��� *)

let rec try_exploit_neighbors x y prev cur next nref =
  let pixel = cur.(x) in
  if nref <= 4 then

    (* �Փ˖ʔԍ����L��(��)�� *)
    if get_surface_id pixel nref >= 0 then
      (* ����4�_��⊮�Ɏg���邩 *)
      if neighbors_are_available x prev cur next nref then (

	(* �Ԑڎ�����v�Z����t���O�������Ă���Ύ��ۂɌv�Z���� *)
	let calc_diffuse = p_calc_diffuse pixel in
        if calc_diffuse.(nref) then
	  calc_diffuse_using_5points x prev cur next nref
	else ();

	(* ���̔��ˏՓ˓_�� *)
	try_exploit_neighbors x y prev cur next (nref + 1)
      ) else
	(* ����4�_��⊮�Ɏg���Ȃ��̂ŁA�������g��Ȃ����@�ɐ؂�ւ��� *)
	do_without_neighbors cur.(x) nref
    else ()
  else ()
in

(******************************************************************************
   PPM�t�@�C���̏������݊֐�
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
   ���郉�C���̌v�Z�ɕK�v�ȏ����W�߂邽�ߎ��̃��C���̒ǐՂ��s���Ă����֐��Q
 *****************************************************************************)

(* �Ԑڌ��̃T���v�����O�ł͏㉺���E4�_�̌��ʂ��g���̂ŁA���̃��C���̌v�Z��
   �s��Ȃ��ƍŏI�I�ȃs�N�Z���̒l���v�Z�ł��Ȃ� *)

(* �Ԑڌ��� 60�{(20%)�����v�Z���Ă����֐� *)
let rec pretrace_diffuse_rays pixel nref =
  if nref <= 4 then

    (* �ʔԍ����L���� *)
    let sid = get_surface_id pixel nref in
    if sid >= 0 then (
      (* �Ԑڌ����v�Z����t���O�������Ă��邩 *)
      let calc_diffuse = p_calc_diffuse pixel in
      if calc_diffuse.(nref) then (
	let group_id = p_group_id pixel in
	vecbzero diffuse_ray;

	(* 5�̕����x�N�g���W��(�e60�{)���玩���̃O���[�vID�ɑΉ����镨��
	   ��I��Œǐ� *)
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

(* �e�s�N�Z���ɑ΂��Ē��ڌ��ǐՂƊԐڎ����20%���̌v�Z���s�� *)

let rec pretrace_pixels line x group_id lc0 lc1 lc2 =
  if x >= 0 then (

    let xdisp = scan_pitch.(0) *. float_of_int (x - image_center.(0)) in
    ptrace_dirvec.(0) <- xdisp *. screenx_dir.(0) +. lc0;
    ptrace_dirvec.(1) <- xdisp *. screenx_dir.(1) +. lc1;
    ptrace_dirvec.(2) <- xdisp *. screenx_dir.(2) +. lc2;
    vecunit_sgn ptrace_dirvec false;
    vecbzero rgb;
    veccpy startp viewpoint;

    (* ���ڌ��ǐ� *)
    trace_ray 0 1.0 ptrace_dirvec line.(x) 0.0;
    veccpy (p_rgb line.(x)) rgb;
    p_set_group_id line.(x) group_id;

    (* �Ԑڌ���20%��ǐ� *)
    pretrace_diffuse_rays line.(x) 0;

    pretrace_pixels line (x-1) (add_mod5 group_id 1) lc0 lc1 lc2

   ) else ()
in

(* ���郉�C���̊e�s�N�Z���ɑ΂����ڌ��ǐՂƊԐڎ��20%���̌v�Z������ *)
let rec pretrace_line line y group_id =
  let ydisp = scan_pitch.(0) *. float_of_int (y - image_center.(1)) in

  (* ���C���̒��S�Ɍ������x�N�g�����v�Z *)
  let lc0 = ydisp *. screeny_dir.(0) +. screenz_dir.(0) in
  let lc1 = ydisp *. screeny_dir.(1) +. screenz_dir.(1) in
  let lc2 = ydisp *. screeny_dir.(2) +. screenz_dir.(2) in
  pretrace_pixels line (image_size.(0) - 1) group_id lc0 lc1 lc2
in


(******************************************************************************
   ���ڌ��ǐՂƊԐڌ�20%�ǐՂ̌��ʂ���ŏI�I�ȃs�N�Z���l���v�Z����֐�
 *****************************************************************************)

(* �e�s�N�Z���̍ŏI�I�ȃs�N�Z���l���v�Z *)
let rec scan_pixel x y prev cur next =
  if x < image_size.(0) then (

    (* �܂��A���ڌ��ǐՂœ���ꂽRGB�l�𓾂� *)
    veccpy rgb (p_rgb cur.(x));

    (* ���ɁA���ڌ��̊e�Փ˓_�ɂ��āA�Ԑڎ���ɂ���^���������� *)
    if neighbors_exist x y next then
      try_exploit_neighbors x y prev cur next 0
    else
      do_without_neighbors cur.(x) 0;

    (* ����ꂽ�l��PPM�t�@�C���ɏo�� *)
    write_rgb ();

    scan_pixel (x + 1) y prev cur next
   ) else ()
in

(* �ꃉ�C�����̃s�N�Z���l���v�Z *)
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
   �s�N�Z���̏����i�[����f�[�^�\���̊��蓖�Ċ֐��Q
 *****************************************************************************)

(* 3�����x�N�g����5�v�f�z������蓖�� *)
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

(* �s�N�Z����\��tuple�����蓖�� *)
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

(* ������1���C�����̊e�s�N�Z���v�f�����蓖�Ă� *)
let rec init_line_elements line n =
  if n >= 0 then (
    line.(n) <- create_pixel();
    init_line_elements line (n-1)
   ) else
    line
in

(* ������1���C�����̃s�N�Z���z������ *)
let rec create_pixelline _ =
  let line = create_array image_size.(0) (create_pixel()) in
  init_line_elements line (image_size.(0)-2)
in

(******************************************************************************
   �Ԑڌ��̃T���v�����O�ɂ��������x�N�g���Q���v�Z����֐��Q
 *****************************************************************************)

(* �x�N�g���B���o���邾����l�ɕ��z����悤�A600�{�̕����x�N�g���̌������߂�
   �����̏�̊e�ʂ�100�{�����z�����A����ɁA100�{�������̏�̖ʏ��10 x 10 ��
   �i�q��ɕ��Ԃ悤�Ȕz����g���B���̔z��ł͕��p�ɂ��x�N�g���̖��x�̍���
   �傫���̂ŁA����ɕ␳�����������̂��ŏI�I�ɗp���� *)

let rec tan x =
  sin(x) /. cos(x)
in

(* �x�N�g���B���o���邾�����ʏ�Ɉ�l�ɕ��z����悤���W��␳���� *)
let rec adjust_position h ratio =
  let l = sqrt(h*.h +. 0.1) in
  let tan_h = 1.0 /. l in
  let theta_h = atan tan_h in
   let tan_m = tan (theta_h *. ratio) in
  tan_m *. l
in

(* �x�N�g���B���o���邾�����ʏ�Ɉ�l�ɕ��z����悤�Ȍ������v�Z���� *)
let rec calc_dirvec icount x y rx ry group_id index =
  if icount >= 5 then (
    let l = sqrt(fsqr x +. fsqr y +. 1.0) in
    let vx = x /. l in
    let vy = y /. l in
    let vz = 1.0 /. l in

    (* �����̓I�ɑΏ̂ɕ��z������ *)
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

(* �����̏�� 10x10�i�q�̍s���̊e�x�N�g�����v�Z���� *)
let rec calc_dirvecs col ry group_id index =
  if col >= 0 then (
    (* ������ *)
    let rx = (float_of_int col) *. 0.2 -. 0.9 in (* ��̍��W *)
    calc_dirvec 0 0.0 0.0 rx ry group_id index;
    (* �E���� *)
    let rx2 = (float_of_int col) *. 0.2 +. 0.1 in (* ��̍��W *)
    calc_dirvec 0 0.0 0.0 rx2 ry group_id (index + 2);

    calc_dirvecs (col - 1) ry (add_mod5 group_id 1) index
   ) else ()
in

(* �����̏��10x10�i�q�̊e�s�ɑ΂��x�N�g���̌������v�Z���� *)
let rec calc_dirvec_rows row group_id index =
  if row >= 0 then (
    let ry = (float_of_int row) *. 0.2 -. 0.9 in (* �s�̍��W *)
    calc_dirvecs 4 ry group_id index; (* ��s���v�Z *)
    calc_dirvec_rows (row - 1) (add_mod5 group_id 2) (index + 4)
   ) else ()
in

(******************************************************************************
   dirvec �̃��������蓖�Ă��s��
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
   �⏕�֐��B���Ăяo����dirvec�̏��������s��
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
   ���S���ʔ��ː����������̂̔��ˏ�������������
 *****************************************************************************)

(* ���˕��ʂ�ǉ����� *)
let rec add_reflection index surface_id bright v0 v1 v2 =
  let dvec = create_dirvec() in
  vecset (d_vec dvec) v0 v1 v2; (* ���ˌ��̌��� *)
  setup_dirvec_constants dvec;

  reflections.(index) <- (surface_id, dvec, bright)
in

(* �����̂̊e�ʂɂ��ď���ǉ����� *)
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

(* ���ʂɂ��ď���ǉ����� *)
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


(* �e�I�u�W�F�N�g�ɑ΂��A���˂��镽�ʂ�����΂��̏���ǉ����� *)
let rec setup_reflections obj_id =
  if obj_id >= 0 then
    let obj = objects.(obj_id) in
    if o_reflectiontype obj = 2 then
      if fless (o_diffuse obj) 1.0 then
	let m_shape = o_form obj in
	(* �����̂ƕ��ʂ̂݃T�|�[�g *)
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
   �S�̂̐���
 *****************************************************************************)

(* ���C�g���̊e�X�e�b�v���s���֐��������Ăяo�� *)
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
