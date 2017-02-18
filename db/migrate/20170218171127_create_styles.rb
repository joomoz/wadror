class CreateStyles < ActiveRecord::Migration
  def change
    create_table :styles do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end

    # Reload column infromation
    Style.reset_column_information

    # Populate with existing styles
    different_styles = Beer.all.map{ |beer| beer.style }.uniq

    different_styles.each do |style|
      Style.create(name: style, description:"No Description")
    end

    change_table :beers do |t|
      t.rename :style, :old_style
      t.integer :style_id
    end

    # Reload column info and add new styles to beers
    Beer.reset_column_information
    Style.reset_column_information

    Beer.all.each do |beer|
      beer.update(style_id: Style.all.find_by(name: beer.old_style).id)
    end

    #Remove old_style from beers
    change_table :beers do |t|
      t.remove :old_style
    end

  end
end
