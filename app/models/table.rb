class Table < ActiveRecord::Base
  belongs_to :session
  belongs_to :scenario
  has_many :registration_tables
  has_many :game_masters
  delegate :name, to: :scenario
  delegate :start, to: :session
  delegate :end, to: :session
  delegate :prereg_ends, to: :session
  delegate :prereg_closed?, to: :session
  validates :scenario_id, :session_id, :max_players, :gms_needed, :presence => true
  validates_numericality_of :gms_needed, :max_players, greater_than: 0

  def <=> (tab)
    # Remove "Table"  and sort by number, if possible.
    myloc  = self.location.to_s.downcase[/\d+/]
    tabloc = tab.location.to_s.downcase[/\d+/]
    sort   = myloc.to_i <=> tabloc.to_i

    if sort == 0
      sort = self.location.to_s <=> tab.location.to_s
    end
    if sort == 0
      sort = self.raffle.to_s <=> tab.raffle.to_s

    end
    if sort == 0
      sort = self.core.to_s <=> tab.core.to_s
    end

    if sort == 0
      sort = self.scenario <=> tab.scenario
    end
    sort
  end

  def long_name
    "#{scenario.long_name} [#{session.name}]"
  end

  def check_player_count
    errors.add :registration_tables
  end

  def remaining_seats
    self.max_players - current_registrations
  end

  def current_registrations
    self.registration_tables.length
  end

  def need_gms?
    gms_short > 0
  end

  def gms_short
    self.gms_needed - current_gms
  end

  def current_gms
    self.game_masters.length
  end


  def price
    session.event.prereg_closed? ? onsite_price : prereg_price
  end

  def early_bird_discount?
    self.price < self.onsite_price
  end

  def gm_table_assignments
    tabs        = []
    game_masters.collect {|gm|
      unless gm.table_number.blank?
        tabs << gm.table_number.strip
      end
    }
    # sort by the number...
    tabs.sort_by{|x| x[/\d+/].to_i}.join(", ")
  end


end
