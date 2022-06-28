\connect wallabydb
CREATE TABLE wallaby.kinematic_model (

  "ID" BIGSERIAL PRIMARY KEY,
  "Name", varchar NOT NULL,
  "RA", double_precision NOT NULL,
  "DEC", double_precision NOT NULL,
  "freq", double_precision NOT NULL,
  "team_release", varchar NOT NULL,
  "team_release_kin", varchar NOT NULL,
  "Vsys_model", double_precision NOT NULL,
  "e_Vsys_model", double_precision NOT NULL,
  "X_model", double_precision NOT NULL,
  "e_X_model", double_precision NOT NULL,
  "Y_model", double_precision NOT NULL,
  "e_Y_model", double_precision NOT NULL,
  "RA_model", double_precision NOT NULL,
  "e_RA_model", double_precision NOT NULL,
  "DEC_model", double_precision NOT NULL,
  "e_DEC_model", double_precision NOT NULL,
  "Inc_model", double_precision NOT NULL,
  "e_Inc_model", double_precision NOT NULL,
  "PA_model", double_precision NOT NULL,
  "e_PA_model", double_precision NOT NULL,
  "PA_model_g", double_precision NOT NULL,
  "e_PA_model_g", double_precision NOT NULL,
  "QFlag_model", integer NOT NULL,
  "Rad", varchar NOT NULL,
  "Vrot_model", varchar NOT NULL,
  "e_Vrot_model", varchar NOT NULL,
  "e_Vrot_model_inc", varchar NOT NULL,
  "Rad_SD", varchar NOT NULL,
  "SD_model", varchar NOT NULL,
  "e_SD_model", varchar NOT NULL,
  "SD_FO_model", varchar NOT NULL,
  "e_SD_FO_model_inc", varchar NOT NULL,
);
ALTER TABLE wallaby.kinematic_model ADD FOREIGN KEY ("Name") REFERENCES wallaby.source ("name") ON DELETE CASCADE;

