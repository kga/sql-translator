#!/usr/local/bin/perl
# vim: set ft=perl:

use strict;
use Test::More tests => 2;
use Test::Differences;
use SQL::Translator;
use FindBin '$Bin';

my $yaml = q/--- #YAML:1.0
schema:
  procedures: {}
  tables:
    person:
      comments: ''
      fields:
        age:
          data_type: integer
          default_value: ~
          extra: {}
          is_nullable: 1
          is_primary_key: 0
          is_unique: 0
          name: age
          order: 3
          size:
            - 0
        description:
          data_type: text
          default_value: ~
          extra: {}
          is_nullable: 1
          is_primary_key: 0
          is_unique: 0
          name: description
          order: 6
          size:
            - 0
        iq:
          data_type: tinyint
          default_value: 0
          extra: {}
          is_nullable: 1
          is_primary_key: 0
          is_unique: 0
          name: iq
          order: 5
          size:
            - 0
        name:
          data_type: varchar
          default_value: ~
          extra: {}
          is_nullable: 0
          is_primary_key: 0
          is_unique: 1
          name: name
          order: 2
          size:
            - 20
        person_id:
          data_type: INTEGER
          default_value: ~
          extra: {}
          is_nullable: 0
          is_primary_key: 1
          is_unique: 0
          name: person_id
          order: 1
          size:
            - 0
        weight:
          data_type: double
          default_value: ~
          extra: {}
          is_nullable: 1
          is_primary_key: 0
          is_unique: 0
          name: weight
          order: 4
          size:
            - 11
            - 2
      indices: {}
      name: person
      options: []
      order: 1
    pet:
      comments: ''
      fields:
        age:
          data_type: int
          default_value: ~
          extra: {}
          is_nullable: 1
          is_primary_key: 0
          is_unique: 0
          name: age
          order: 10
          size:
            - 0
        name:
          data_type: varchar
          default_value: ~
          extra: {}
          is_nullable: 1
          is_primary_key: 0
          is_unique: 0
          name: name
          order: 9
          size:
            - 30
        person_id:
          data_type: int
          default_value: ~
          extra: {}
          is_nullable: 0
          is_primary_key: 1
          is_unique: 0
          name: person_id
          order: 8
          size:
            - 0
        pet_id:
          data_type: int
          default_value: ~
          extra: {}
          is_nullable: 0
          is_primary_key: 1
          is_unique: 0
          name: pet_id
          order: 7
          size:
            - 0
      indices: {}
      name: pet
      options: []
      order: 2
  triggers:
    after:
      action:
        for_each: ~
        steps:
          - update name=name
        when: ~
      database_event: insert
      fields: ~
      name: after
      on_table: ~
      order: 1
      perform_action_when: ~
  views:
    person_pet:
      fields: ~
      name: person_pet
      order: 1
      sql: |
        select pr.person_id, pr.name as person_name, pt.name as pet_name
          from   person pr, pet pt
          where  person.person_id=pet.pet_id
/;

my $tr = SQL::Translator->new(
    parser   => 'SQLite',
    producer => 'YAML',
    filename => "$Bin/data/sqlite/create.sql",
);

my $out;
ok( $out = $tr->translate, 'Translate SQLite to YAML' );
eq_or_diff( $out, $yaml, 'YAML matches expected' );
